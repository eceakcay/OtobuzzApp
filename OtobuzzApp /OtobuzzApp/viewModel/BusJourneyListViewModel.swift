//  BusJourneyListViewModel.swift
//  OtobuzzApp
//
//  Created by Ece Akcay on 17.04.2025.
//

import Foundation

class BusJourneyListViewModel: ObservableObject {
    @Published var journeys: [Journey] = []
    @Published var currentDate: Date
    @Published var showingSortOptions: Bool = false
    @Published var showingFilterOptions: Bool = false
    @Published var showingSeatSelection: Bool = false // Koltuk seçimi için
    @Published var selectedJourney: Journey? // Seçilen sefer
    
    // HomeViewModel’den gelen veriler
    let homeViewModel: HomeViewModel
    
    // Orijinal seferleri saklamak için (filtreleme sırasında kullanılacak)
    private var originalJourneys: [Journey] = []
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.currentDate = homeViewModel.selectedDate
        loadJourneys()
    }
    
    // Model: Journey yapısı
    struct Journey: Identifiable {
        let id = UUID()
        let companyName: String
        let companyLogo: String
        let departureTime: String
        let duration: String
        let price: Double
        let seatLayout: String
        let features: [String]
        let seats: [Seat] // Koltuk verisi
        
        struct Seat: Identifiable {
            let id: Int
            let isOccupied: Bool
            let gender: Gender? // nil ise boş koltuk
        }
        
        enum Gender {
            case male
            case female
        }
    }
    
    // Sefer verilerini yükleme
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
                            companyLogo: trip.firma.lowercased(), // örnek: "kamilkoç" → logo adıyla eşleşiyorsa
                            departureTime: trip.saat,
                            duration: "6s", // sürenin API'den gelmediğini varsaydım
                            price: Double(trip.fiyat),
                            seatLayout: "2+1", // örnek varsayım
                            features: [], // şu an API'de yok
                            seats: trip.koltuklar.enumerated().map { index, seat in
                                Journey.Seat(
                                    id: seat.numara,
                                    isOccupied: seat.secili,
                                    gender: nil // gender backend'den gelmediği için nil
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

    
    // Tarih formatlama (ör. "18 Nisan Cuma")
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM EEEE"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    // Tarih navigasyonu
    func previousDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
    }
    
    func nextDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    // Sıralama işlemleri
    func sortByPriceAscending() {
        journeys.sort { $0.price < $1.price }
    }
    
    func sortByPriceDescending() {
        journeys.sort { $0.price > $1.price }
    }
    
    // Filtreleme işlemleri
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
