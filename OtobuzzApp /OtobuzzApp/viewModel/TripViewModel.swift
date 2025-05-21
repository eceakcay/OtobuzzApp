//
//  TripViewModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 21.05.2025.
//

import Foundation

class TripListViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchTrips() {
        isLoading = true
        errorMessage = nil

        APIService.shared.get(endpoint: "trips", responseType: [Trip].self) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let trips):
                    self.trips = trips
                    print("✅ Seferler yüklendi: \(trips.count) adet")
                case .failure(let error):
                    self.errorMessage = "Seferler alınamadı: \(error.localizedDescription)"
                    print("❌ Hata: \(error.localizedDescription)")
                }
            }
        }
    }
}
