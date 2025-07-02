import Foundation

class APIService {
    static let shared = APIService()
    
    private let baseURL = "http://127.0.0.1:3000/api"
    // Gerçek cihazda IP ayarla:
    // private let baseURL = "http://192.168.X.X:3000/api"

    // MARK: - Generic GET
    func get<T: Decodable>(
        endpoint: String,
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let encodedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/\(encodedEndpoint)") else {
            print("❌ Hatalı URL: \(endpoint)")
            return completion(.failure(.invalidURL))
        }

        print("🌐 Full URL: \(url.absoluteString)")

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ GET Error: \(error.localizedDescription)")
                return completion(.failure(.requestFailed(error)))
            }

            guard let data = data else {
                print("❌ GET Error: no data")
                return completion(.failure(.noData))
            }

            print("🧪 Gelen JSON verisi:")
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print("JSON verisi çözülemedi.")
            }

            do {
                let decoded = try JSONDecoder().decode(responseType, from: data)
                print("✅ GET Başarılı: \(decoded)")
                completion(.success(decoded))
            } catch {
                print("❌ JSON decode hatası:", error)
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

    // MARK: - Trip detay çekme
    func getTripDetail(tripId: String, completion: @escaping (Result<Trip, APIError>) -> Void) {
        get(endpoint: "trips/\(tripId)", responseType: Trip.self, completion: completion)
    }

    func getCities(completion: @escaping (Result<[String], APIError>) -> Void) {
        get(endpoint: "trips/cities", responseType: [String].self, completion: completion)
    }

    // MARK: - Bilet rezervasyonu (Ödeme beklemede)
    func createTicket(request: TicketRequest, completion: @escaping (Result<TicketResponse, APIError>) -> Void) {
        post(endpoint: "tickets/buy", body: request, responseType: TicketResponse.self, completion: completion)
    }

    // MARK: - Ödeme tamamlama
    func completePayment(ticketId: String, completion: @escaping (Result<TicketResponse, APIError>) -> Void) {
        let endpoint = "tickets/pay"
        let body = ["ticketId": ticketId]
        post(endpoint: endpoint, body: body, responseType: TicketResponse.self, completion: completion)
    }

    // MARK: - Generic POST
    func post<T: Encodable, U: Decodable>(
        endpoint: String,
        body: T,
        responseType: U.Type,
        completion: @escaping (Result<U, APIError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return completion(.failure(.invalidURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let json = try JSONEncoder().encode(body)
            request.httpBody = json
            print("📤 POST Gönderilen JSON: \(String(data: json, encoding: .utf8) ?? "Kodlanamadı")")
        } catch {
            print("❌ POST Encode Error: \(error)")
            return completion(.failure(.requestFailed(error)))
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ POST Error: \(error.localizedDescription)")
                return completion(.failure(.requestFailed(error)))
            }

            guard let data = data else {
                print("❌ POST Error: no data")
                return completion(.failure(.noData))
            }

            do {
                let decoded = try JSONDecoder().decode(U.self, from: data)
                print("✅ POST Başarılı: \(decoded)")
                completion(.success(decoded))
            } catch {
                print("❌ POST Decode Error: \(error)")
                print("📩 POST Gelen JSON: \(String(data: data, encoding: .utf8) ?? "boş")")
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

    // MARK: - Hata Enum'u
    enum APIError: Error {
        case invalidURL
        case requestFailed(Error)
        case noData
        case decodingError(Error)
    }
}
