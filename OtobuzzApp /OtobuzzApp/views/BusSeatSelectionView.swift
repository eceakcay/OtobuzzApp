import SwiftUI

struct BusSeatSelectionView: View {
    let journey: BusJourneyListViewModel.Journey
    @Environment(\.dismiss) var dismiss
    @AppStorage("userId") var userId: String = ""
    @State private var isPaymentViewActive = false
    @State private var selectedSeat: BusJourneyListViewModel.Journey.Seat?
    @State private var showAlert = false

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
        NavigationStack {
            ZStack {
                backgroundGradient

                VStack(spacing: 20) {
                    headerView
                    seatGridView
                    occupancySummaryView
                    paymentButtonView
                }
                .padding(.vertical, 20)
                .background(contentBackground)
                .padding(.horizontal, 20)
                .navigationDestination(isPresented: $isPaymentViewActive) {
                    Payment(
                        journeyPrice: journey.price,
                        selectedSeat: selectedSeat,
                        tripId: journey.id.uuidString,
                        userId: userId
                    )
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
            VStack(spacing: 12) {
                ForEach(0..<journey.seats.count / 4, id: \.self) { rowIndex in
                    HStack(spacing: 16) {
                        SeatView(seat: journey.seats[rowIndex * 4], selectedSeat: $selectedSeat)
                        SeatView(seat: journey.seats[rowIndex * 4 + 1], selectedSeat: $selectedSeat)

                        Spacer().frame(width: 40)

                        SeatView(seat: journey.seats[rowIndex * 4 + 3], selectedSeat: $selectedSeat)
                    }
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
                Text("Seçilen Koltuk: \(selected.id) (\(selected.gender == .female ? "Kadın" : "Erkek"))")
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
    @State private var showGenderSelection = false

    var body: some View {
        if seat.id == 0 {
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
                    showGenderSelection = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPressed.toggle()
                    }
                }
            }
            .sheet(isPresented: $showGenderSelection) {
                GenderSelectionView(seat: seat, selectedSeat: $selectedSeat)
                    .presentationDetents([.height(240)])
                    .presentationBackground(.ultraThinMaterial)
                    .presentationCornerRadius(20)
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

struct GenderSelectionView: View {
    let seat: BusJourneyListViewModel.Journey.Seat
    @Binding var selectedSeat: BusJourneyListViewModel.Journey.Seat?
    @Environment(\.dismiss) var dismiss
    @State private var isFemalePressed = false
    @State private var isMalePressed = false

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                GenderButton(
                    title: "Kadın",
                    icon: "person.crop.circle.fill",
                    color: .pink.opacity(0.8),
                    isPressed: $isFemalePressed,
                    action: {
                        withAnimation {
                            isFemalePressed = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isFemalePressed = false
                            }
                        }
                        if let currentSeat = selectedSeat {
                            selectedSeat = BusJourneyListViewModel.Journey.Seat(
                                id: currentSeat.id,
                                isOccupied: true,
                                gender: .female
                            )
                        }
                        dismiss()
                    }
                )

                GenderButton(
                    title: "Erkek",
                    icon: "person.crop.circle.fill",
                    color: .blue.opacity(0.8),
                    isPressed: $isMalePressed,
                    action: {
                        withAnimation {
                            isMalePressed = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isMalePressed = false
                            }
                        }
                        if let currentSeat = selectedSeat {
                            selectedSeat = BusJourneyListViewModel.Journey.Seat(
                                id: currentSeat.id,
                                isOccupied: true,
                                gender: .male
                            )
                        }
                        dismiss()
                    }
                )
            }

            Button(action: {
                withAnimation {
                    selectedSeat = nil
                    dismiss()
                }
            }) {
                Text("İptal")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(radius: 8)
        )
        .padding()
    }
}

struct GenderButton: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var isPressed: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)

                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(width: 120, height: 100)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [color, color.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(15)
            .shadow(color: color.opacity(0.4), radius: 5, x: 0, y: 3)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
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
                    var seatNumber = 1
                    for _ in 0..<10 {
                        seatArray.append(.init(id: seatNumber, isOccupied: Bool.random(), gender: seatNumber % 4 == 0 ? .female : .male))
                        seatNumber += 1
                        seatArray.append(.init(id: seatNumber, isOccupied: Bool.random(), gender: seatNumber % 3 == 0 ? .female : .male))
                        seatNumber += 1
                        seatArray.append(.init(id: 0, isOccupied: false, gender: nil)) // koridor
                        seatArray.append(.init(id: seatNumber, isOccupied: Bool.random(), gender: seatNumber % 2 == 0 ? .male : .female))
                        seatNumber += 1
                    }
                    return seatArray
                }()
            )
        )
    }
}
