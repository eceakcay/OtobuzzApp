import SwiftUI

struct Payment: View {
    @ObservedObject private var paymentViewModel: PaymentViewModel
    @Environment(\.dismiss) var dismiss
    
    init(journeyPrice: Double, selectedSeat: BusJourneyListViewModel.Journey.Seat?) {
        self.paymentViewModel = PaymentViewModel(journeyPrice: journeyPrice, selectedSeat: selectedSeat)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            // Custom App Bar
            ZStack(alignment: .topLeading) {
                CustomAppBar() // Ensure CustomAppBar takes no arguments
            }
            
            // Credit Card Image and Card Number
            ZStack(alignment: .topLeading) {
                Image("KrediKarti")
                    .scaledToFit()
                    .frame(width: 400, height: 200)
                    .padding(.vertical, 10)
                
                Text(paymentViewModel.cardNumber.isEmpty ? "•••• •••• •••• ••••" : paymentViewModel.cardNumber)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.top, 105)
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
                            .foregroundColor(.main.opacity(0.9))
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
                            .foregroundColor(.main.opacity(0.9))
                            .padding(.top, 20)
                            .padding(.leading, 20)
                        
                        Button(action: {
                            paymentViewModel.processPayment()
                        }) {
                            Text("Ödeme Yap")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.altinSarisi)
                                .cornerRadius(8)
                                .shadow(radius: 4)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                }
            }
        }
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
