//
//  TicketsView.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 30.05.2025.
//



import SwiftUI

// Örnek bilet modeli (gerçek model backend'e göre uyarlanabilir)
struct Ticket: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let date: String
    let time: String
    let busCompany: String
    let seatNumber: Int
}

// Demo veri
let sampleTickets = [
    Ticket(from: "Ankara", to: "İstanbul", date: "30 Mayıs 2025", time: "09:00", busCompany: "Kamil Koç", seatNumber: 12),
    Ticket(from: "İzmir", to: "Bursa", date: "1 Haziran 2025", time: "14:30", busCompany: "Pamukkale", seatNumber: 5)
]

struct TicketsView: View {
    // Gelecekte: @ObservedObject var ticketManager = TicketManager()
    var tickets: [Ticket] = sampleTickets

    var body: some View {
        NavigationView {
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

                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(tickets) { ticket in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("\(ticket.from) → \(ticket.to)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(ticket.busCompany)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Text("Tarih: \(ticket.date)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Text("Saat: \(ticket.time) • Koltuk No: \(ticket.seatNumber)")
                                        .font(.footnote)
                                        .foregroundColor(.gray.opacity(0.8))
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
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TicketsView()
}
