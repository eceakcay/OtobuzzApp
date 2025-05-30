//
//  UserModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 30.05.2025.
//

import Foundation

struct User: Codable {
    let _id: String  // <-- backend'den gelen MongoDB ID
    let ad: String
    let email: String
}
