import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showPassword: Bool = false
    @State private var isButtonPressed: Bool = false
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false
    @State private var navigateToBusJourneyList: Bool = false // Yönlendirme için
    
    private let primaryColor = Color.orange
    private let correctEmail = "mine.kirmaci@example.com"
    private let correctPassword = "123456"

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.orange.opacity(0.05), .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image(systemName: "bus.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                        .padding(.top, 20)
                    
                    Text("Hoş Geldiniz")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                    
                    // Email TextField
                    CustomTextField(placeholder: "E-posta", text: $email, icon: "envelope")
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .scaleEffect(isEmailFocused ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isEmailFocused)
                        .onTapGesture {
                            withAnimation {
                                isEmailFocused = true
                                isPasswordFocused = false
                            }
                        }
                        .onChange(of: email) { _ in
                            withAnimation {
                                isEmailFocused = false
                            }
                        }
                    
                    // Password SecureField
                    CustomSecureField(placeholder: "Şifre", text: $password, showPassword: $showPassword)
                        .scaleEffect(isPasswordFocused ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isPasswordFocused)
                        .onTapGesture {
                            withAnimation {
                                isPasswordFocused = true
                                isEmailFocused = false
                            }
                        }

                    if showError {
                        Text(errorMessage)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .transition(.opacity)
                    }
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isButtonPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isButtonPressed = false
                            login()
                        }
                    }) {
                        Text("Giriş Yap")
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
                    
                    HStack(spacing: 20) {
                        NavigationLink(destination: RegisterView()) {
                            Text("Kayıt Ol")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.orange)
                                .padding(.vertical, 8)
                        }
                        
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Şifremi Unuttum")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.orange)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
        
                    NavigationLink(
                        destination: Home(),
                        isActive: $navigateToBusJourneyList
                    ) {
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
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private func login() {
        withAnimation {
            if email.isEmpty || password.isEmpty {
                showError = true
                errorMessage = "Lütfen tüm alanları doldurun."
            } else if !isValidEmail(email) {
                showError = true
                errorMessage = "Geçerli bir e-posta girin."
            } else if email != correctEmail || password != correctPassword {
                showError = true
                errorMessage = "E-posta veya şifre hatalı."
            } else {
                showError = false
                isLoggedIn = true
                navigateToBusJourneyList = true 
                print("Giriş başarılı, isLoggedIn: \(isLoggedIn)")
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange.opacity(0.7))
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16, design: .rounded))
                .accentColor(.orange)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .orange.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.orange.opacity(0.7))
                .frame(width: 20)
            
            if showPassword {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16, design: .rounded))
                    .accentColor(.orange)
            } else {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16, design: .rounded))
                    .accentColor(.orange)
            }
            
            Button(action: { showPassword.toggle() }) {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.orange.opacity(0.7))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .orange.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    NavigationStack {
        LoginView(isLoggedIn: .constant(false))
    }
}
