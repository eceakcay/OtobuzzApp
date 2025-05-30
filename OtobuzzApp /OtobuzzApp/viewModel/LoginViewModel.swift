import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var sifre = ""
    @Published var loginSuccess = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var navigateToHome = false

    func loginUser() {
        // Giriş öncesi validasyon
        guard !email.isEmpty, !sifre.isEmpty else {
            showError = true
            errorMessage = "Lütfen tüm alanları doldurun."
            return
        }
        guard isValidEmail(email) else {
            showError = true
            errorMessage = "Geçerli bir e-posta girin."
            return
        }

        let loginData = LoginRequest(email: email, sifre: sifre)

        APIService.shared.post(
            endpoint: "auth/login",
            body: loginData,
            responseType: LoginResponse.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // ✅ Kullanıcı ID’sini kaydet (Profil ekranı buradan okuyacak)
                    UserDefaults.standard.set(response.userId, forKey: "loggedInUserId")

                    // ✅ Konsola debug çıktısı
                    print("✅ Giriş başarılı, userId: \(response.userId)")
                    print("🧠 Kaydedilen ID (UserDefaults): \(UserDefaults.standard.string(forKey: "loggedInUserId") ?? "YOK")")

                    self.showError = false
                    self.loginSuccess = true
                    self.navigateToHome = true
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = "E-posta veya şifre hatalı."
                    print("❌ Giriş başarısız: \(error.localizedDescription)")
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}
