import SwiftUI

struct Payment: View {
    @ObservedObject private var paymentViewModel: PaymentViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showSaveCardAlert = false
    @State private var navigateToSavedCards = false

    init(journeyPrice: Double, selectedSeat: BusJourneyListViewModel.Journey.Seat?, tripId: String, userId: String) {
        self.paymentViewModel = PaymentViewModel(journeyPrice: journeyPrice, selectedSeat: selectedSeat, userId: userId, tripId: tripId)
    }

    var body: some View {
        VStack(spacing: 5) {
            CustomAppBar()
                .frame(height: 50)

            ZStack(alignment: .topLeading) {
                Image("KrediKarti")
                    .scaledToFit()
                    .frame(width: 400, height: 200)
                    .padding(.top, 50)

                Text(paymentViewModel.cardNumber.isEmpty ? "•••• •••• •••• ••••" : paymentViewModel.cardNumber)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.top, 145)
                    .padding(.leading, 90)
            }
            .padding(.bottom, 40)

            VStack(alignment: .leading, spacing: 20) {
                Text("Kart Bilgileri")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)

                TextField("Kart Numarası", text: $paymentViewModel.cardNumber)
                    .keyboardType(.numberPad)
                    .modifier(FormTextFieldStyle())
                    .onChange(of: paymentViewModel.cardNumber) { _, newValue in
                        paymentViewModel.cardNumber = paymentViewModel.filterInput(newValue)
                    }

                HStack(spacing: 15) {
                    TextField("Son Kullanma", text: $paymentViewModel.expirationDate)
                        .keyboardType(.numberPad)
                        .modifier(FormTextFieldStyle())
                        .onChange(of: paymentViewModel.expirationDate) { _, newValue in
                            paymentViewModel.expirationDate = paymentViewModel.filterInput(newValue)
                        }

                    TextField("CVV", text: $paymentViewModel.cvv)
                        .keyboardType(.numberPad)
                        .modifier(FormTextFieldStyle())
                        .onChange(of: paymentViewModel.cvv) { _, newValue in
                            paymentViewModel.cvv = paymentViewModel.filterInput(newValue)
                        }
                }

                Text("Ödeme Tutarı: \(paymentViewModel.paymentAmount, specifier: "%.2f") TL")
                    .font(.headline)
                    .foregroundColor(.orange)

                Button(action: {
                    paymentViewModel.processPayment()
                    if isCardValid() {
                        showSaveCardAlert = true
                    }
                }) {
                    Text("Ödeme Yap")
                        .padding()
                        .frame(width: 270, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                if paymentViewModel.paymentStarted {
                    Text(paymentViewModel.paymentStatus)
                        .font(.headline)
                        .foregroundColor(paymentViewModel.isPaymentSuccessful() ? .green : .red)
                }
            }
            .padding(.horizontal, 30)

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(
            LinearGradient(colors: [.white, .orange.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .alert("Kartı kaydetmek ister misiniz?", isPresented: $showSaveCardAlert) {
            Button("Hayır", role: .cancel) {}
            Button("Evet") {
                let card = CardModel(
                    cardHolderName: "Mine Kırmacı",
                    cardNumber: maskedCardNumber(paymentViewModel.cardNumber),
                    expiryDate: paymentViewModel.expirationDate,
                    imageName: "visa"
                )
                SavedCardsManager.shared.addCard(card)
                navigateToSavedCards = true
            }
        }
        .background(
            NavigationLink(destination: SavedCardsView(), isActive: $navigateToSavedCards) {
                EmptyView()
            }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                }
            }
        }
    }

    func maskedCardNumber(_ number: String) -> String {
        let trimmed = number.filter { $0.isNumber }
        if trimmed.count >= 4 {
            let last4 = trimmed.suffix(4)
            return "**** **** **** \(last4)"
        }
        return "**** **** ****"
    }

    func isCardValid() -> Bool {
        return !paymentViewModel.cardNumber.isEmpty &&
               !paymentViewModel.expirationDate.isEmpty &&
               !paymentViewModel.cvv.isEmpty
    }

    struct FormTextFieldStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 3, x: 1, y: 1)
        }
    }
}

#Preview {
    NavigationStack {
        Payment(
            journeyPrice: 460.0,
            selectedSeat: BusJourneyListViewModel.Journey.Seat(id: 1, isOccupied: false, gender: nil),
            tripId: "example_trip_id",
            userId: "example_user_id"
        )
    }
}
