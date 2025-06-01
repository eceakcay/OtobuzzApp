//
//  TicketModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 1.06.2025.
//

import Foundation

struct TicketRequest: Codable {
    let userId: String
    let tripId: String
    let koltukNo: Int
    let cinsiyet: String
    let odemeDurumu: String
    let onay: Bool
}
