//
//  ProfileOptionRow.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 20.04.2025.
//

import SwiftUICore

// Profil içindeki satır komponenti
struct ProfileOptionRow: View {
    var icon: String
    var label: String
    var color: Color = .primary
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(label)
                .foregroundColor(color)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}


