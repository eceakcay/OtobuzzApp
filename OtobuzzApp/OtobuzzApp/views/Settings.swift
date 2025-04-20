import SwiftUI

struct Settings: View {
    @State private var name: String = "Mine Kırmacı"
    @State private var email: String = "mine.kirmaci@example.com"
    @State private var notificationsEnabled: Bool = true
    @State private var password: String = ""
    
    @Environment(\.presentationMode) var presentationMode  // Geri dönüş için ekledik
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profil Fotoğrafı")) {
                    HStack {
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }

                Section(header: Text("Bilgiler")) {
                    TextField("İsim", text: $name)
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                }

                Section(header: Text("Gizlilik")) {
                    SecureField("Yeni Şifre", text: $password)
                    Toggle("Bildirimleri Aç", isOn: $notificationsEnabled)
                }

                Section {
                    Button(action: {
                        // Burada bilgileri kaydetme işlemleri yapılabilir
                        print("Kaydedildi: \(name), \(email)")
                        
                        // Kaydetme işlemi tamamlandığında geri dönme
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Kaydet")
                                .bold()
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

#Preview {
    Settings()
}
