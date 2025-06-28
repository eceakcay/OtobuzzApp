//
//  TripModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 21.05.2025.
//

struct Trip: Codable, Identifiable {
    let id: String
    let saat: String
    let firma: String
    let fiyat: Int
    let koltuklar: [Seat]
    let kalkisSehri: String
    let varisSehri: String
    let tarih: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case saat, firma, fiyat, koltuklar, kalkisSehri, varisSehri, tarih
    }
}

struct Seat: Codable, Identifiable {
    var id: Int { numara }
    let numara: Int
    let secili: Bool
    let cinsiyet: String

    var isOccupied: Bool {
        secili
    }

    var gender: Gender {
        cinsiyet.lowercased() == "kadın" ? .female : .male
    }

    enum Gender {
        case female, male
    }
}
