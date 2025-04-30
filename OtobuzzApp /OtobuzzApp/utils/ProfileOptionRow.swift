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
    var color: Color = .black
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            
            Text(label)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.main)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 2)
        )
    }
}

