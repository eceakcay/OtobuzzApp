import SwiftUI

struct CustomNavigationBar: View {
    let title1 = "Ara"
    let title2 = "Profilim"
    
    @Binding var selectedTab: String
    
    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 100) {
                // Ara Butonu
                NavigationLink(destination: Home()) {
                    VStack(spacing: 5) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 30))
                            .foregroundColor(selectedTab == title1 ? .main : .black)
                        Text(title1)
                            .font(.system(size: 18))
                            .foregroundColor(selectedTab == title1 ? .main : .black)
                    }
                }

                // Profil Butonu
                NavigationLink(destination: Profile()) { 
                    VStack(spacing: 5) {
                        Image(systemName: "person")
                            .font(.system(size: 30))
                            .foregroundColor(selectedTab == title2 ? .main : .black)
                        Text(title2)
                            .font(.system(size: 18))
                            .foregroundColor(selectedTab == title2 ? .main : .black)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.2))
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    @State static var selectedTab = "Ara"

    static var previews: some View {
        CustomNavigationBar(selectedTab: $selectedTab)
    }
}
