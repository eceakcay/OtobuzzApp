//
//  CustomAppBar.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 29.03.2025.
//

import SwiftUI

struct CustomAppBar: View {
    var body: some View {
        HStack {
            Text("OtoBuzz")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
                .frame(alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.orange)
    }
}

#Preview {
    CustomAppBar()
}

