//
//  SavedCardsManager.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 22.04.2025.
//
import Foundation
import Combine

class SavedCardsManager: ObservableObject {
    static let shared = SavedCardsManager()
    
    @Published var savedCards: [CardModel] = []
    private let userDefaultsKey = "savedCards"

    private init() {
        loadCards()
    }

    func addCard(_ card: CardModel) {
        savedCards.append(card)
        saveCards()
    }

    func removeCard(at offsets: IndexSet) {
        savedCards.remove(atOffsets: offsets)
        saveCards()
    }

    private func saveCards() {
        if let encoded = try? JSONEncoder().encode(savedCards) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    private func loadCards() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([CardModel].self, from: data) else {
            savedCards = []
            return
        }
        savedCards = decoded
    }
}


