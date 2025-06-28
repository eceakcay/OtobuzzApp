//
//  APIService.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 20.05.2025.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    // 🔁 Eğer simülatörde çalışıyorsan:
    private let baseURL = "http://127.0.0.1:3000/api"
    // Gerçek cihazda çalışıyorsan yukarıdaki satırı değiştirip IP adresini kullan:
    // private let baseURL = "http://192.168.X.X:3000/api"

    // MARK: - Generic GET
    func get<T: Decodable>(
        endpoint: String,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let encodedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/\(encodedEndpoint)") else {
            print("❌ Hatalı URL: \(endpoint)")
            return completion(.failure(APIError.invalidURL))
        }

        print("🌐 Full URL: \(url.absoluteString)")

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ GET Error: \(error.localizedDescription)")
                return completion(.failure(error))
            }

            guard let data = data else {
                print("❌ GET Error: no data")
                return completion(.failure(APIError.noData))
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                print("✅ GET Başarılı: \(decoded)")
                completion(.success(decoded))
            } catch {
                print("❌ GET Decode Error: \(error)")
                print("📩 GET JSON: \(String(data: data, encoding: .utf8) ?? "boş")")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getTripDetail(tripId: String, completion: @escaping (Result<Trip, Error>) -> Void) {
        get(endpoint: "trips/\(tripId)", responseType: Trip.self, completion: completion)
    }
    
    func getCities(completion: @escaping (Result<[String], Error>) -> Void) {
        get(endpoint: "trips/cities", responseType: [String].self, completion: completion)
    }

    // MARK: - Generic POST
    func post<T: Encodable, U: Decodable>(
        endpoint: String,
        body: T,
        responseType: U.Type,
        completion: @escaping (Result<U, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return completion(.failure(APIError.invalidURL))
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
            return completion(.failure(error))
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ POST Error: \(error.localizedDescription)")
                return completion(.failure(error))
            }

            guard let data = data else {
                print("❌ POST Error: no data")
                return completion(.failure(APIError.noData))
            }

            do {
                let decoded = try JSONDecoder().decode(U.self, from: data)
                print("✅ POST Başarılı: \(decoded)")
                completion(.success(decoded))
            } catch {
                print("❌ POST Decode Error: \(error)")
                print("📩 POST Gelen JSON: \(String(data: data, encoding: .utf8) ?? "boş")")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func updateSeat(for tripId: String, seatNumber: Int, gender: String, completion: @escaping (Result<Trip, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/trips/\(tripId)/seats") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "numara": seatNumber,
            "cinsiyet": gender
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let updatedTrip = try JSONDecoder().decode(Trip.self, from: data)
                completion(.success(updatedTrip))
            } catch {
                print("❌ JSON decode hatası: \(error.localizedDescription)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("🪵 Gelen veri: \(responseString)")
                }
                completion(.failure(error))
            }
        }.resume()
    }


    enum APIError: Error {
        case invalidURL
        case noData
    }
}
