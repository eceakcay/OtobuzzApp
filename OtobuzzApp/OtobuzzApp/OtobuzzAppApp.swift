//
//  OtobuzzAppApp.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 29.03.2025.
//

import SwiftUI

@main
struct OtobuzzAppApp: App {
    @State private var isLoggedIn: Bool = false 

    var body: some Scene {
        WindowGroup {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
    }
}
