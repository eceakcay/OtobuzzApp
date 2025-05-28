//
//  home_viewModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 29.03.2025.
//

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
                    self?.cities = sehirler
                    // İlk 2 şehri otomatik ata
                    if let first = sehirler.first {
                        self?.nereden = first
                        self?.nereye = sehirler.count > 1 ? sehirler[1] : first
                    }
                case .failure(let error):
                    print("❌ Şehirler alınamadı: \(error.localizedDescription)")
                    // Hata durumunda fallback veriler
                    self?.cities = ["İstanbul", "Ankara", "İzmir", "Bursa"]
                    self?.nereden = "İstanbul"
                    self?.nereye = "Ankara"
                }
            }
        }
    }
}
