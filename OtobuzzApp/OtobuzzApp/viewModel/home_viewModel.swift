//
//  home_viewModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 29.03.2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var nereden: String = "İstanbul"
    @Published var nereye: String = "İstanbul"
    @Published var selectedDate: Date = Date() // Tarih değişkeni eklendi

    
    let cities = ["İstanbul", "Ankara", "İzmir", "Bursa", "Antalya", "Adana", "Konya", "Gaziantep"]
}
