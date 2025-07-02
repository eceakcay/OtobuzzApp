import Foundation

// 🎟 Ticket içindeki trip bilgisi için sade model
struct TicketTrip: Codable {
    let kalkisSehri: String
    let varisSehri: String
    let tarih: String
    let saat: String
    let firma: String
    let fiyat: Int
}

// 🎫 Ticket Modeli
struct TicketModel: Identifiable, Codable {
    let id: String
    let userId: String
    let trip: TicketTrip
    let koltukNo: Int
    let cinsiyet: String
    let odemeDurumu: String
    let onay: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId = "user"
        case trip
        case koltukNo
        case cinsiyet
        case odemeDurumu
        case onay
    }
}

// 📨 Ticket POST etmek için kullanılan model
struct TicketRequest: Codable {
    let userId: String
    let tripId: String
    let koltukNo: Int
    let cinsiyet: String
}

// 🎯 API'den dönen yanıt modeli
struct TicketResponse: Codable {
    let message: String
    let ticket: TicketModel?
}
