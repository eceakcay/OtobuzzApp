import SwiftUI

struct Payment: View {
    @ObservedObject private var payment_viewModel = PaymentViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 5) {
                
                ZStack(alignment: .topLeading) {
                    CustomAppBar()
                }
                
                
                ZStack(alignment: .topLeading) {
                    Image("KrediKarti")
                        .scaledToFit()
                        .frame(width: 400, height: 200)
                        .padding(.vertical, 10)

                    Text(payment_viewModel.cardNumber.isEmpty ? "•••• •••• •••• ••••" : payment_viewModel.cardNumber)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top, 105)
                        .padding(.leading, 90)
                }
                

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

                            TextField("Kart Numarası", text: $payment_viewModel.cardNumber)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                .padding(.horizontal, 20)
                                .onChange(of: payment_viewModel.cardNumber) { oldValue, newValue in
                                    payment_viewModel.cardNumber = payment_viewModel.filterInput(newValue)
                                }

                            HStack {
                                TextField("Son Kullanma Tarihi", text: $payment_viewModel.expirationDate)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                                    .onChange(of: payment_viewModel.expirationDate) { oldValue, newValue in
                                        payment_viewModel.expirationDate = payment_viewModel.filterInput(newValue)
                                    }

                                
                                TextField("CVV", text: $payment_viewModel.cvv)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                                    .onChange(of: payment_viewModel.cvv) { oldValue, newValue in
                                        payment_viewModel.cvv = payment_viewModel.filterInput(newValue)
                                    }
                            }
                            .padding(.horizontal, 20)

                            Text("Ödeme Tutarı: \(payment_viewModel.paymentAmount)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.main.opacity(0.9))
                                .padding(.top, 20)
                                .padding(.leading, 20)

                            Button(action: {
                                payment_viewModel.processPayment()
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

                            if payment_viewModel.paymentStarted {
                                Text(payment_viewModel.paymentStatus)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(payment_viewModel.isPaymentSuccessful() ? .blue : .red)
                                    .padding(.leading, 20)
                            }

                        }
                    )
                Spacer()
            }
        }
    }
}
#Preview {

Payment()

}
