import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @State private var confirmPassword: String = ""
    @State private var isButtonPressed = false
    @State private var isEmailFocused = false
    @State private var isPasswordFocused = false
    @State private var isConfirmPasswordFocused = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.05), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Kayıt Ol")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.top, 20)

                Text("Hesap oluşturmak için bilgilerinizi girin.")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.gray.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // Ad Soyad TextField
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.orange.opacity(0.7))
                        .frame(width: 20)

                    TextField("Ad Soyad", text: $viewModel.ad)
                        .autocapitalization(.words)
                        .font(.system(size: 16, design: .rounded))
                        .accentColor(.orange)
                }
                .paddingField(focused: false)

                // Email TextField
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.orange.opacity(0.7))
                        .frame(width: 20)

                    TextField("E-posta", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .font(.system(size: 16, design: .rounded))
                        .accentColor(.orange)
                }
                .paddingField(focused: isEmailFocused)
                .onTapGesture {
                    isEmailFocused = true
                    isPasswordFocused = false
                    isConfirmPasswordFocused = false
                }

                // Password SecureField
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.orange.opacity(0.7))
                        .frame(width: 20)

                    SecureField("Şifre", text: $viewModel.sifre)
                        .font(.system(size: 16, design: .rounded))
                        .accentColor(.orange)
                }
                .paddingField(focused: isPasswordFocused)
                .onTapGesture {
                    isPasswordFocused = true
                    isEmailFocused = false
                    isConfirmPasswordFocused = false
                }

                // Confirm Password SecureField
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.orange.opacity(0.7))
                        .frame(width: 20)

                    SecureField("Şifreyi Onayla", text: $confirmPassword)
                        .font(.system(size: 16, design: .rounded))
                        .accentColor(.orange)
                }
                .paddingField(focused: isConfirmPasswordFocused)
                .onTapGesture {
                    isConfirmPasswordFocused = true
                    isEmailFocused = false
                    isPasswordFocused = false
                }

                if viewModel.showError, let error = viewModel.errorMessage {
                    Text(error)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }

                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isButtonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isButtonPressed = false

                        // Şifre eşleşmesini kontrol et
                        guard viewModel.sifre == confirmPassword else {
                            viewModel.showError = true
                            viewModel.errorMessage = "Şifreler eşleşmiyor."
                            return
                        }

                        viewModel.registerUser()
                    }
                }) {
                    Text("Kayıt Ol")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .orange.opacity(0.3), radius: 6, x: 0, y: 4)
                }
                .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                .padding(.top, 8)

                Spacer()

                NavigationLink(destination: Home(), isActive: $viewModel.navigateToHome) {
                    EmptyView()
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 40)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.orange.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 24))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - View Extension for Shared Styling
extension View {
    func paddingField(focused: Bool) -> some View {
        self
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: .orange.opacity(0.2), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(focused ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: focused)
    }
}


#Preview {
    NavigationView {
        RegisterView()
    }
}
