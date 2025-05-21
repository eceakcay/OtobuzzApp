//
//  RegisterModels.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 21.05.2025.
//

import Foundation


// 📤 API'ye gönderilecek kayıt verisi
struct RegisterRequest: Codable {
    let ad: String
    let email: String
    let sifre: String
}

// 📥 API'den dönen yanıt
struct RegisterResponse: Codable {
    let message: String
    let user: RegisteredUser
    let token: String
}

// 👤 API'den gelen user objesi
struct RegisteredUser: Codable {
    let _id: String
    let email: String
}

