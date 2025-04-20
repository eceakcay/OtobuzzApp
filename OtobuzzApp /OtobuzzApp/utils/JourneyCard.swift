import SwiftUI

struct JourneyCard: View {
    let journey: BusJourneyListViewModel.Journey
    let from: String
    let to: String
    @EnvironmentObject var viewModel: BusJourneyListViewModel
    @State private var isButtonPressed = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            // Firma Logosu
            Image(journey.companyLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            
            // Orta Kısım: Saat, Süre, Güzergah
            VStack(alignment: .leading, spacing: 8) {
                // Saat ve Süre
                HStack {
                    Text(journey.departureTime)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Spacer()
                    Text("○ \(journey.duration)")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                // Güzergah
                Text("\(from) Otogarı → \(to) Otogarı")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.gray)
                
                // Koltuk Düzeni
                Text(journey.seatLayout)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.gray)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
                
                // Ek Özellikler
                if !journey.features.isEmpty {
                    HStack(spacing: 5) {
                        ForEach(journey.features, id: \.self) { feature in
                            HStack(spacing: 5) {
                                if feature == "Şehir İçi Servis" {
                                    Image(systemName: "bus.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.orange)
                                } else if feature == "100% İNDİRİM KODU" {
                                    Image(systemName: "tag.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.orange)
                                }
                                Text(feature)
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(.orange)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(6)
                        }
                    }
                }
            }
            
            // Sağ Kısım: Fiyat ve İncele Butonu
            VStack(alignment: .trailing, spacing: 10) {
                Text("\(String(format: "%.0f", journey.price)) TL")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isButtonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isButtonPressed = false
                        viewModel.selectedJourney = journey
                        viewModel.showingSeatSelection = true
                    }
                }) {
                    Text("İncele")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(10)
                        .shadow(color: .orange.opacity(0.2), radius: 2)
                }
                .scaleEffect(isButtonPressed ? 0.95 : 1.0)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    JourneyCard(
        journey: BusJourneyListViewModel.Journey(
            companyName: "EROVA",
            companyLogo: "erova_logo",
            departureTime: "01:00",
            duration: "6s 1dk",
            price: 460.0,
            seatLayout: "2+1",
            features: ["Şehir İçi Servis", "100% İNDİRİM KODU"],
            seats: []
        ),
        from: "Isparta",
        to: "Ankara"
    )
    .environmentObject(BusJourneyListViewModel(homeViewModel: HomeViewModel()))
}
