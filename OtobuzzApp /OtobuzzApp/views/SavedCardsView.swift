import SwiftUI

struct SavedCardsView: View {
    @ObservedObject var cardsManager = SavedCardsManager.shared
    
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
                    Text("Kayıtlı Kartlarım")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .center)

                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(cardsManager.savedCards) { card in
                                HStack(spacing: 15) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(card.cardHolderName)
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(.black)

                                        Text(card.cardNumber)
                                            .font(.system(size: 14, design: .rounded))
                                            .foregroundColor(.gray)

                                        Text("Son Kullanma: \(card.expiryDate)")
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundColor(.gray.opacity(0.7))
                                    }

                                    Spacer()

                                    Image(card.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 30)
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
    SavedCardsView()
}
