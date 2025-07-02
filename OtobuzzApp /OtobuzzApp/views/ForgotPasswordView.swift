import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @State private var isTextFieldFocused = false
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
                Text("Şifremi Unuttum")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.top, 20)

                Text("E-posta adresinize geçici şifre gönderilecektir.")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.gray.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.orange.opacity(0.7))
                        .frame(width: 20)

                    TextField("E-posta", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .font(.system(size: 16, design: .rounded))
                        .padding(.vertical, 12)
                        .accentColor(.orange)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: .orange.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                .scaleEffect(isTextFieldFocused ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isTextFieldFocused)
                .onTapGesture {
                    withAnimation {
                        isTextFieldFocused = true
                    }
                }
                .onChange(of: viewModel.email) { _, _ in
                    withAnimation {
                        isTextFieldFocused = false
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(1.2)
                }

                Button(action: {
                    viewModel.resetPassword()
                }) {
                    Text("Bağlantı Gönder")
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
                .disabled(viewModel.email.isEmpty || viewModel.isLoading)
                .scaleEffect(viewModel.email.isEmpty || viewModel.isLoading ? 0.95 : 1.0)
                .padding(.top, 8)

                Spacer()
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.isSuccess ? "Başarılı" : "Hata"),
                message: Text(viewModel.alertMessage ?? ""),
                dismissButton: .default(Text("Tamam")) {
                    if viewModel.isSuccess {
                        dismiss()
                    }
                }
            )
        }
    }
}

#Preview {
    NavigationView {
        ForgotPasswordView()
    }
}
