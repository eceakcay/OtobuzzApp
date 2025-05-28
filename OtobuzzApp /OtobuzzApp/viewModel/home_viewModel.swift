import Foundation

class HomeViewModel: ObservableObject {
    @Published var nereden: String = ""
    @Published var nereye: String = ""
    @Published var selectedDate: Date = Date()
    @Published var cities: [String] = []

    init() {
        fetchCities()
    }

    func fetchCities() {
        APIService.shared.getCities { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sehirler):
                    self?.cities = sehirler.sorted() // İstersen alfabetik sırala
                    // İlk 2 şehri otomatik ata
                    if let first = sehirler.first {
                        self?.nereden = first
                        self?.nereye = sehirler.count > 1 ? sehirler[1] : first
                    }
                    print("✅ Şehirler başarıyla yüklendi: \(sehirler)")
                case .failure(let error):
                    print("❌ Şehirler alınamadı: \(error.localizedDescription)")
                    // Hata durumunda fallback veriler
                    self?.cities = ["İstanbul", "Ankara", "İzmir", "Bursa","Isparta"]
                    self?.nereden = "İstanbul"
                    self?.nereye = "Ankara"
                }
            }
        }
    }
}
