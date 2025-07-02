//
//  TicketsView.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 30.05.2025.
//

import SwiftUI

struct TicketsView: View {
    @StateObject private var viewModel = TicketsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.orange.opacity(0.1), .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Biletlerim")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .center)

                    if viewModel.isLoading {
                        ProgressView("Biletler yükleniyor...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if viewModel.tickets.isEmpty {
                        Text("Henüz biletiniz yok.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.tickets) { ticket in
                                    VStack(alignment: .leading, spacing: 8) {
                                        // ✅ Yeni gösterim: Sefer bilgileri
                                        Text("\(ticket.trip.kalkisSehri) → \(ticket.trip.varisSehri)")
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        Text("\(ticket.trip.saat) - \(ticket.trip.firma)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)

                                        Text("Koltuk No: \(ticket.koltukNo)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)

                                        Text("Cinsiyet: \(ticket.cinsiyet) • Ödeme: \(ticket.odemeDurumu)")
                                            .font(.footnote)
                                            .foregroundColor(.gray.opacity(0.8))

                                        if ticket.onay {
                                            Text("✔ Onaylandı")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [.orange, .orange.opacity(0.7)]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        ),
                                                        lineWidth: 2
                                                    )
                                            )
                                    )
                                    .shadow(color: .orange.opacity(0.15), radius: 5, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .onAppear {
                if let userId = UserDefaults.standard.string(forKey: "loggedInUserId") {
                    print("✅ Aktif kullanıcı ID: \(userId)") // Debug için ekledik
                    viewModel.fetchTickets(for: userId)
                } else {
                    print("❌ Kullanıcı ID bulunamadı (UserDefaults)")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TicketsView()
}
