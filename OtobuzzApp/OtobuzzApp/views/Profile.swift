import SwiftUI

struct Profile: View {
    @State private var selectedTab: String = "Profilim"
    @State private var isLoggedIn: Bool = true
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Profil Fotoğrafı ve Bilgiler burada
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.altinSarisi)
                    
                    Text("Mine Kırmacı")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("mine.kirmaci@example.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                Divider().padding(.horizontal)

                // Ayarlar / Yardım / Çıkış ayarları burada
                VStack(alignment: .leading, spacing: 16) {
                    NavigationLink(destination: Settings()) {
                        ProfileOptionRow(icon: "gearshape", label: "Ayarlar")
                    }
                    
                    NavigationLink(destination: Help()) {
                        ProfileOptionRow(icon: "questionmark.circle", label: "Yardım")
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
        }
    }
}
#Preview {
    Profile()
}

