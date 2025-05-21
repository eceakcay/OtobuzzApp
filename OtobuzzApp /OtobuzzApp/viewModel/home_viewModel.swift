//
//  home_viewModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 29.03.2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var nereden: String
    @Published var nereye: String
    @Published var selectedDate: Date

    let cities = ["İstanbul", "Ankara", "İzmir", "Bursa", "Antalya", "Adana", "Konya", "Gaziantep"]

    init() {
        // Test için varsayılan olarak farklı şehirler verelim
        self.nereden = "İstanbul"
        self.nereye = "Ankara"
        self.selectedDate = Date()
    }
}
