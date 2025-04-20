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
        let loadedJourneys = [
            Journey(
                companyName: "EROVA",
                companyLogo: "erova_logo",
                departureTime: "01:00",
                duration: "6s 1dk",
                price: 460.0,
                seatLayout: "2+1",
                features: [],
                seats: (1...40).map { i in
                    Journey.Seat(
                        id: i,
                        isOccupied: Bool.random() && i % 2 == 0,
                        gender: i % 4 == 0 ? .female : i % 2 == 0 ? .male : nil
                    )
                }
            ),
            Journey(
                companyName: "Isparta",
                companyLogo: "ıspartapetrol_logo",
                departureTime: "03:10",
                duration: "5s 30dk",
                price: 540.0,
                seatLayout: "2+1",
                features: ["100% İNDİRİM KODU", "Şehir İçi Servis"],
                seats: (1...40).map { i in
                    Journey.Seat(
                        id: i,
                        isOccupied: Bool.random() && i % 2 == 0,
                        gender: i % 4 == 0 ? .female : i % 2 == 0 ? .male : nil
                    )
                }
            ),
            Journey(
                companyName: "Pamukkale",
                companyLogo: "pamukkale_logo",
                departureTime: "05:30",
                duration: "6s",
                price: 600.0,
                seatLayout: "2+1",
                features: [],
                seats: (1...40).map { i in
                    Journey.Seat(
                        id: i,
                        isOccupied: Bool.random() && i % 2 == 0,
                        gender: i % 4 == 0 ? .female : i % 2 == 0 ? .male : nil
                    )
                }
            ),
            Journey(
                companyName: "KamilKoç",
                companyLogo: "kamilkoc_logo",
                departureTime: "08:30",
                duration: "6s",
                price: 490.0,
                seatLayout: "2+1",
                features: [],
                seats: (1...40).map { i in
                    Journey.Seat(
                        id: i,
                        isOccupied: Bool.random() && i % 2 == 0,
                        gender: i % 4 == 0 ? .female : i % 2 == 0 ? .male : nil
                    )
                }
            ),
            Journey(
                companyName: "Isparta",
                companyLogo: "ıspartapetrol_logo",
                departureTime: "12:00",
                duration: "5s 15dk",
                price: 540.0,
                seatLayout: "2+1",
                features: ["100% İNDİRİM KODU", "Şehir İçi Servis"],
                seats: (1...40).map { i in
                    Journey.Seat(
                        id: i,
                        isOccupied: Bool.random() && i % 2 == 0,
                        gender: i % 4 == 0 ? .female : i % 2 == 0 ? .male : nil
                    )
                }
            )
        ]
        journeys = loadedJourneys
        originalJourneys = loadedJourneys
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
