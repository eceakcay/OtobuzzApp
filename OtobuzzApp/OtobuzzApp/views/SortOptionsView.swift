import SwiftUI

struct SortOptionsView: View {
    @ObservedObject var viewModel: BusJourneyListViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    SortOptionButton(
                        title: "Fiyata Göre (Artan)",
                        systemImage: "arrow.up.circle.fill",
                        color: .orange
                    ) {
                        viewModel.sortByPriceAscending()
                        viewModel.showingSortOptions = false
                    }

                    SortOptionButton(
                        title: "Fiyata Göre (Azalan)",
                        systemImage: "arrow.down.circle.fill",
                        color: .orange
                    ) {
                        viewModel.sortByPriceDescending()
                        viewModel.showingSortOptions = false
                    }
                }
                .padding()

                Spacer()

                Button(action: {
                    viewModel.showingSortOptions = false
                }) {
                    Text("Kapat")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(Color.orange)
                        .cornerRadius(14)
                        .shadow(color: Color.orange.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Sırala")
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.1), Color.orange.opacity(0.05)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
}

struct SortOptionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .shadow(color: Color.orange.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    SortOptionsView(viewModel: BusJourneyListViewModel(homeViewModel: HomeViewModel()))
}

