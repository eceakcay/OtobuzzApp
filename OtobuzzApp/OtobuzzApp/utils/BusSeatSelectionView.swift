import SwiftUI

struct BusSeatSelectionView: View {
    let journey: BusJourneyListViewModel.Journey
    @Environment(\.dismiss) var dismiss
    @State private var isPaymentViewActive = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.05), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Otobüs Koltuk Düzeni")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                
                Text("\(journey.companyName) - \(journey.departureTime)")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.gray.opacity(0.8))
                
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()), // Sol 1. koltuk
                            GridItem(.flexible()), // Sol 2. koltuk
                            GridItem(.fixed(40)),  // Koridor
                            GridItem(.flexible())  // Sağ koltuk
                        ],
                        spacing: 10
                    ) {
                        ForEach(journey.seats) { seat in
                            SeatView(seat: seat)
                        }
                    }
                    .padding()
                }
                
                let occupiedCount = journey.seats.filter { $0.isOccupied }.count
                let femaleCount = journey.seats.filter { $0.isOccupied && $0.gender == .female }.count
                let maleCount = journey.seats.filter { $0.isOccupied && $0.gender == .male }.count
                
                VStack(spacing: 8) {
                    Text("Doluluk: \(occupiedCount)/\(journey.seats.filter { $0.id != 0 }.count)")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.black)
                    Text("Kadın: \(femaleCount) | Erkek: \(maleCount)")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 10)
                
                NavigationLink(
                    destination: Payment(),
                    isActive: $isPaymentViewActive
                ) {
                    Button(action: {
                        isPaymentViewActive = true
                    }) {
                        Text("Ödeme Sayfasına Git")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: .orange.opacity(0.2), radius: 2)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.orange.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)
        }
    }
}

struct SeatView: View {
    let seat: BusJourneyListViewModel.Journey.Seat
    @State private var isPressed = false
    
    var body: some View {
        if seat.id == 0 { // Koridor
            Color.clear.frame(width: 40, height: 40)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(seatColor)
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                
                Text("\(seat.id)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                if !seat.isOccupied {
                    withAnimation { isPressed.toggle() }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPressed.toggle()
                    }
                }
            }
        }
    }
    
    var seatColor: Color {
        if !seat.isOccupied {
            return .gray.opacity(0.3)
        }
        return seat.gender == .female ? .pink : .blue
    }
}


#Preview {
    NavigationView {
        BusSeatSelectionView(
            journey: BusJourneyListViewModel.Journey(
                companyName: "EROVA",
                companyLogo: "erova_logo",
                departureTime: "01:00",
                duration: "6s 1dk",
                price: 460.0,
                seatLayout: "2+1",
                features: [],
                seats: {
                    var seatArray: [BusJourneyListViewModel.Journey.Seat] = []
                    let totalSeats = 40
                    let seatsPerRow = 3
                    var seatNumber = 1
                    
                    for _ in 0..<(totalSeats / seatsPerRow) {
                        seatArray.append(.init(
                            id: seatNumber,
                            isOccupied: Bool.random() && seatNumber % 2 == 0,
                            gender: seatNumber % 4 == 0 ? .female : seatNumber % 2 == 0 ? .male : nil
                        ))
                        seatNumber += 1
                        
                        seatArray.append(.init(
                            id: seatNumber,
                            isOccupied: Bool.random() && seatNumber % 2 == 0,
                            gender: seatNumber % 4 == 0 ? .female : seatNumber % 2 == 0 ? .male : nil
                        ))
                        seatNumber += 1
                        
                        seatArray.append(.init(id: 0, isOccupied: false, gender: nil))
                        
                        seatArray.append(.init(
                            id: seatNumber,
                            isOccupied: Bool.random() && seatNumber % 2 == 0,
                            gender: seatNumber % 4 == 0 ? .female : seatNumber % 2 == 0 ? .male : nil
                        ))
                        seatNumber += 1
                    }
                    return seatArray
                }()
            )
        )
    }
}
