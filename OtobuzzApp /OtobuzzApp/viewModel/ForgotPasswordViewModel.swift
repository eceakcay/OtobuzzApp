import Foundation

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var alertMessage: String? = nil
    @Published var showAlert: Bool = false
    @Published var isSuccess: Bool = false

    func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Lütfen e-posta adresinizi girin."
            showAlert = true
            return
        }

        isLoading = true
        alertMessage = nil
        isSuccess = false

        APIService.shared.forgotPassword(email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let message):
                    self?.alertMessage = message
                    self?.isSuccess = true
                case .failure(let error):
                    self?.alertMessage = "Hata: \(error.localizedDescription)"
                }
                self?.showAlert = true
            }
        }
    }
}
