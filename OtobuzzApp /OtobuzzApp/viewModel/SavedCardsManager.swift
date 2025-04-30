//
//  SavedCardsManager.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 22.04.2025.
//
import Foundation

class SavedCardsManager: ObservableObject {
    static let shared = SavedCardsManager()
    
    @Published var savedCards: [CardModel] = []
    
    private init() {}
    
    func addCard(_ card: CardModel) {
        savedCards.append(card)
    }
}

