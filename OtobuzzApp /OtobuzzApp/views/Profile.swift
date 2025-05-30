import SwiftUI

struct Profile: View {
    @State private var selectedTab: String = "Profilim"
    @State private var isLoggedIn: Bool = true
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // Profil Fotoğrafı ve Dinamik Bilgiler
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.altinSarisi)
                    
                    if let user = viewModel.user {
                        Text(user.ad)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text("Yükleniyor...")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 20)

                Divider().padding(.horizontal)

                // Ayarlar / Yardım / Çıkış ayarları burada
                VStack(alignment: .leading, spacing: 16) {
                    
                    NavigationLink(destination: TicketsView()) {
                        ProfileOptionRow(icon: "ticket", label: "Biletlerim")
                    }
                    
                    NavigationLink(destination: SavedCardsView()) {
                        ProfileOptionRow(icon: "creditcard", label: "Kayıtlı Kartlarım")
                    }
                    
                    NavigationLink(destination: Help()) {
                        ProfileOptionRow(icon: "questionmark.circle", label: "Yardım")
                    }
                    
                    NavigationLink(destination: Settings()) {
                        ProfileOptionRow(icon: "gearshape", label: "Ayarlar")
                    }
                    
                    NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)) {
                        ProfileOptionRow(icon: "arrow.right.circle", label: "Çıkış Yap", color: .red)
                    }

                }
                .padding(.horizontal)
                
                Spacer()
                CustomNavigationBar(selectedTab: $selectedTab)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.fetchUserProfile()
            }
        }
    }
}

#Preview {
    Profile()
}
