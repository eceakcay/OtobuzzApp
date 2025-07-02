//
//  LoginModels.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 20.05.2025.
//


import Foundation

struct LoginRequest: Codable {
    let email: String
    let sifre: String
}

struct LoginResponse: Codable {
    let userId: String
    let token: String
    let userName: String
}

