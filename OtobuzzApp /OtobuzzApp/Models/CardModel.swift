//
//  CardModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 22.04.2025.
//

import Foundation

struct CardModel: Identifiable,Codable {
    let id = UUID()
    let cardHolderName: String
    let cardNumber: String
    let expiryDate: String
    let imageName: String
}



