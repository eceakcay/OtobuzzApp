import Foundation

class RegisterViewModel: ObservableObject {
    @Published var ad = ""
    @Published var email = ""
    @Published var sifre = ""
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var navigateToHome = false

    func registerUser() {
        // 🧪 Validasyon
        guard !ad.isEmpty, !email.isEmpty, !sifre.isEmpty else {
            showError = true
            errorMessage = "Lütfen tüm alanları doldurun."
            return
        }

        guard isValidEmail(email) else {
            showError = true
            errorMessage = "Geçerli bir e-posta girin."
            return
        }

        // ✅ API isteği için gövdeyi oluştur
        let body = RegisterRequest(ad: ad, email: email, sifre: sifre)

        // 🌐 API'ye POST isteği gönder
        APIService.shared.post(
            endpoint: "auth/register",
            body: body,
            responseType: RegisterResponse.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // ✅ Kayıt başarılı → ID'yi kaydet
                    UserDefaults.standard.set(response.user._id, forKey: "loggedInUserId")

                    // ✅ Konsola debug çıktısı
                    print("✅ Kayıt başarılı, userId: \(response.user._id)")
                    print("🧠 Kaydedilen ID (UserDefaults): \(UserDefaults.standard.string(forKey: "loggedInUserId") ?? "boş")")

                    self.navigateToHome = true
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = "Kayıt başarısız: \(error.localizedDescription)"
                    print("❌ Kayıt hatası: \(error)")
                }
            }
        }
    }

    // 📧 Email geçerlilik kontrolü
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
