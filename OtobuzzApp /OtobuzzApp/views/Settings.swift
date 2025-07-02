import SwiftUI

struct Settings: View {
    @State private var name: String = UserDefaults.standard.string(forKey: "loggedInUserName") ?? ""
    @State private var email: String = UserDefaults.standard.string(forKey: "loggedInUserEmail") ?? ""
    @State private var notificationsEnabled: Bool = true
    @State private var password: String = ""
    @State private var goToProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Profil Fotoğrafı
                    VStack {
                        Text("Profil Fotoğrafı")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    // Bilgiler
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Bilgiler")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        RoundedTextField(title: "İsim", text: $name)
                        RoundedTextField(title: "E-posta", text: $email, keyboardType: .emailAddress)
                    }
                    .padding(.horizontal)
                    
                    // Gizlilik
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Gizlilik")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        SecureInputField(title: "Yeni Şifre", text: $password)
                        
                        Toggle(isOn: $notificationsEnabled) {
                            Text("Bildirimleri Aç")
                                .font(.body)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }

                    // Kaydet Butonu
                    Button(action: {
                        // Bilgileri UserDefaults'a kaydet
                        UserDefaults.standard.set(name, forKey: "loggedInUserName")
                        UserDefaults.standard.set(email, forKey: "loggedInUserEmail")
                        // Şifre işlemi backend ile entegre edilebilir
                        
                        print("Kaydedildi: \(name), \(email)")
                        goToProfile = true
                    }) {
                        Text("Kaydet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                            .padding(.horizontal)
                    }

                    // Navigation Link
                    NavigationLink(destination: Profile(), isActive: $goToProfile) {
                        EmptyView()
                    }
                    .hidden()

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Ayarlar")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

struct RoundedTextField: View {
    var title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(title, text: $text)
            .keyboardType(keyboardType)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

struct SecureInputField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        SecureField(title, text: $text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 1)
    }
}


#Preview {
    Settings()
}
