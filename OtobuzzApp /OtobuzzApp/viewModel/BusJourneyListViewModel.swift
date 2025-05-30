import Foundation

class BusJourneyListViewModel: ObservableObject {
    @Published var journeys: [Journey] = []
    @Published var currentDate: Date
    @Published var showingSortOptions: Bool = false
    @Published var showingFilterOptions: Bool = false
    @Published var showingSeatSelection: Bool = false
    @Published var selectedJourney: Journey?

    let homeViewModel: HomeViewModel
    private var originalJourneys: [Journey] = []

    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.currentDate = homeViewModel.selectedDate
        loadJourneys()
    }

    struct Journey: Identifiable {
        let id = UUID()
        let companyName: String
        let companyLogo: String
        let departureTime: String
        let duration: String
        let price: Double
        let seatLayout: String
        let features: [String]
        let seats: [Seat]

        struct Seat: Identifiable {
            let id: Int
            let isOccupied: Bool
            let gender: Gender?
        }

        enum Gender: String, Codable {
            case male = "Erkek"
            case female = "Kadın"
        }
    }

    func loadJourneys() {
        let from = homeViewModel.nereden
        let to = homeViewModel.nereye
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: currentDate)

        let endpoint = "trips?from=\(from)&to=\(to)&tarih=\(dateString)"

        APIService.shared.get(endpoint: endpoint, responseType: [Trip].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let trips):
                    let mapped = trips.map { trip in
                        Journey(
                            companyName: trip.firma,
                            companyLogo: trip.firma.lowercased(),
                            departureTime: trip.saat,
                            duration: "6s",
                            price: Double(trip.fiyat),
                            seatLayout: "2+1",
                            features: [],
                            seats: trip.koltuklar.map { seat in
                                Journey.Seat(
                                    id: seat.numara,
                                    isOccupied: seat.secili,
                                    gender: {
                                        if seat.secili {
                                            switch seat.cinsiyet {
                                            case "Kadın": return .female
                                            case "Erkek": return .male
                                            default: return nil
                                            }
                                        } else {
                                            return nil
                                        }
                                    }()
                                )
                            }
                        )
                    }
                    self.journeys = mapped
                    self.originalJourneys = mapped
                    print("✅ API'den \(mapped.count) sefer geldi.")
                case .failure(let error):
                    print("❌ API Hatası: \(error.localizedDescription)")
                }
            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM EEEE"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }

    func previousDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) {
            currentDate = newDate
            loadJourneys()
        }
    }

    func nextDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
            currentDate = newDate
            loadJourneys()
        }
    }

    func sortByPriceAscending() {
        journeys.sort { $0.price < $1.price }
    }

    func sortByPriceDescending() {
        journeys.sort { $0.price > $1.price }
    }

    func filterByTimeRange(startHour: Int, endHour: Int) {
        journeys = originalJourneys.filter { journey in
            let hour = Int(journey.departureTime.split(separator: ":")[0]) ?? 0
            return hour >= startHour && hour < endHour
        }
    }

    func filterByCompany(_ companyName: String) {
        journeys = originalJourneys.filter { $0.companyName == companyName }
    }

    func resetFilters() {
        journeys = originalJourneys
    }
}
