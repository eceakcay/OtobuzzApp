import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
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
                
                // Email TextField
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.orange.opacity(0.7))
                        .frame(width: 20)
                    
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
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
                .scaleEffect(isEmailFocused ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isEmailFocused)
                .onTapGesture {
                    withAnimation {
                        isEmailFocused = true
                        isPasswordFocused = false
                        isConfirmPasswordFocused = false
                    }
                }
                .onChange(of: email) { _ in
                    withAnimation {
                        isEmailFocused = false
                    }
                }
                
                // Password SecureField
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.orange.opacity(0.7))
                        .frame(width: 20)
                    
                    SecureField("Şifre", text: $password)
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
                .scaleEffect(isPasswordFocused ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPasswordFocused)
                .onTapGesture {
                    withAnimation {
                        isPasswordFocused = true
                        isEmailFocused = false
                        isConfirmPasswordFocused = false
                    }
                }
                .onChange(of: password) { _ in
                    withAnimation {
                        isPasswordFocused = false
                    }
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
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: .orange.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                .scaleEffect(isConfirmPasswordFocused ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isConfirmPasswordFocused)
                .onTapGesture {
                    withAnimation {
                        isConfirmPasswordFocused = true
                        isEmailFocused = false
                        isPasswordFocused = false
                    }
                }
                .onChange(of: confirmPassword) { _ in
                    withAnimation {
                        isConfirmPasswordFocused = false
                    }
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isButtonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isButtonPressed = false
                        dismiss()
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

#Preview {
    NavigationView {
        RegisterView()
    }
}
