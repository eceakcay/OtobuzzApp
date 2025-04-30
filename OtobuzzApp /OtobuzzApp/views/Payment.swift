import SwiftUI

struct Payment: View {
    @ObservedObject private var paymentViewModel: PaymentViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showSaveCardAlert = false
    @State private var navigateToSavedCards = false

    init(journeyPrice: Double, selectedSeat: BusJourneyListViewModel.Journey.Seat?) {
        self.paymentViewModel = PaymentViewModel(journeyPrice: journeyPrice, selectedSeat: selectedSeat)
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

            // Card Information Form
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(radius: 2)
                .frame(width: 350, height: 350)
                .padding()
                .overlay(
                    VStack(alignment: .leading) {
                        Text("KART BİLGİLERİ")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .padding(.top, 20)
                            .padding(.leading, 20)
                        
                        TextField("Kart Numarası", text: $paymentViewModel.cardNumber)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .padding(.horizontal, 20)
                            .onChange(of: paymentViewModel.cardNumber) { oldValue, newValue in
                                paymentViewModel.cardNumber = paymentViewModel.filterInput(newValue)
                            }
                        
                        HStack {
                            TextField("Son Kullanma Tarihi", text: $paymentViewModel.expirationDate)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                .onChange(of: paymentViewModel.expirationDate) { oldValue, newValue in
                                    paymentViewModel.expirationDate = paymentViewModel.filterInput(newValue)
                                }
                            
                            TextField("CVV", text: $paymentViewModel.cvv)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                .onChange(of: paymentViewModel.cvv) { oldValue, newValue in
                                    paymentViewModel.cvv = paymentViewModel.filterInput(newValue)
                                }
                        }
                        .padding(.horizontal, 20)
                        
                        Text("Ödeme Tutarı: \(paymentViewModel.paymentAmount, specifier: "%.2f") TL")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .padding(.top, 20)
                            .padding(.leading, 20)
                        
                        Button(action: {
                            paymentViewModel.processPayment()
                            // Check if the card number, expiration date, and CVV are valid before showing the alert
                            if isCardValid() {
                                showSaveCardAlert = true // Show alert after payment processing
                            }
                        }) {
                            Text("Ödeme Yap")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(8)
                                .shadow(color: .orange.opacity(0.2), radius: 4)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        
                        if paymentViewModel.paymentStarted {
                            Text(paymentViewModel.paymentStatus)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(paymentViewModel.isPaymentSuccessful() ? .blue : .red)
                                .padding(.leading, 20)
                        }
                    }
                )

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.05), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .alert("Kartı kaydetmek ister misiniz?", isPresented: $showSaveCardAlert) {
            Button("Hayır", role: .cancel) {}
            Button("Evet") {
                // Save card if user confirms
                let card = CardModel(
                    cardHolderName: "Mine Kırmacı", // Or you can allow the user to input their name
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

    // Check if card details are valid
    func isCardValid() -> Bool {
        // Check if card number, expiration date, and CVV are non-empty and valid
        return !paymentViewModel.cardNumber.isEmpty &&
               !paymentViewModel.expirationDate.isEmpty &&
               !paymentViewModel.cvv.isEmpty
    }
}

#Preview {
    NavigationStack {
        Payment(
            journeyPrice: 460.0,
            selectedSeat: BusJourneyListViewModel.Journey.Seat(id: 1, isOccupied: false, gender: nil)
        )
    }
}
