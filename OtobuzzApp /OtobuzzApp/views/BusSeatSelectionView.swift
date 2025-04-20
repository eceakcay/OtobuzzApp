import SwiftUI

struct BusSeatSelectionView: View {
    let journey: BusJourneyListViewModel.Journey
    @Environment(\.dismiss) var dismiss
    @State private var isPaymentViewActive = false
    @State private var selectedSeat: BusJourneyListViewModel.Journey.Seat?
    @State private var showAlert = false
    
    // Move computed properties outside the view body
    private var occupiedCount: Int {
        journey.seats.filter { $0.isOccupied }.count
    }
    
    private var femaleCount: Int {
        journey.seats.filter { $0.isOccupied && $0.gender == .female }.count
    }
    
    private var maleCount: Int {
        journey.seats.filter { $0.isOccupied && $0.gender == .male }.count
    }
    
    private var totalSeats: Int {
        journey.seats.filter { $0.id != 0 }.count
    }
    
    var body: some View {
        NavigationStack { // NavigationStack eklendi
            ZStack {
                // Background gradient
                backgroundGradient
                
                // Main content
                VStack(spacing: 20) {
                    // Header
                    headerView
                    
                    // Seat grid
                    seatGridView
                    
                    // Occupancy summary
                    occupancySummaryView
                    
                    // Payment button
                    paymentButtonView
                }
                .padding(.vertical, 20)
                .background(contentBackground)
                .padding(.horizontal, 20)
                .navigationDestination(isPresented: $isPaymentViewActive) {
                    Payment(journeyPrice: journey.price, selectedSeat: selectedSeat)
                }
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.orange.opacity(0.05), .white]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Otobüs Koltuk Düzeni")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.orange)
            
            Text("\(journey.companyName) - \(journey.departureTime)")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.gray.opacity(0.8))
        }
    }
    
    private var seatGridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.fixed(40)),
                    GridItem(.flexible())
                ],
                spacing: 10
            ) {
                ForEach(journey.seats) { seat in
                    SeatView(seat: seat, selectedSeat: $selectedSeat)
                }
            }
            .padding()
        }
    }
    
    private var occupancySummaryView: some View {
        VStack(spacing: 8) {
            Text("Doluluk: \(occupiedCount)/\(totalSeats)")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.black)
            
            Text("Kadın: \(femaleCount) | Erkek: \(maleCount)")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.gray)
            
            if let selected = selectedSeat {
                Text("Seçilen Koltuk: \(selected.id)")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 10)
    }
    
    private var paymentButtonView: some View {
        Button(action: {
            if selectedSeat != nil {
                isPaymentViewActive = true
            } else {
                showAlert = true
            }
        }) {
            Text("Ödeme Sayfasına Git")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(buttonGradient)
                .cornerRadius(12)
                .shadow(color: .orange.opacity(0.2), radius: 2)
        }
        .padding(.horizontal, 40)
        .alert("Koltuk Seçimi", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("Lütfen ödeme yapmadan önce bir koltuk seçin.")
        }
    }
    
    private var buttonGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var contentBackground: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.orange.opacity(0.2), lineWidth: 1)
            )
    }
}

struct SeatView: View {
    let seat: BusJourneyListViewModel.Journey.Seat
    @Binding var selectedSeat: BusJourneyListViewModel.Journey.Seat?
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
                    selectedSeat = seat
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPressed.toggle()
                    }
                }
            }
        }
    }
    
    private var seatColor: Color {
        if !seat.isOccupied {
            return selectedSeat?.id == seat.id ? .green : .gray.opacity(0.3)
        }
        return seat.gender == .female ? .pink : .blue
    }
}

#Preview {
    NavigationStack {
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
