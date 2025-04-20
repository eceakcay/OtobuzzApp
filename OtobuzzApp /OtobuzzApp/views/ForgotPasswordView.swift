import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var isButtonPressed = false
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
                
                Text("E-posta adresinize şifre sıfırlama bağlantısı göndereceğiz.")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.gray.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.orange.opacity(0.7))
                        .frame(width: 20)
                    
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .font(.system(size: 16, design: .rounded))
                        .padding(.vertical, 12)
                        .accentColor(.orange)
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
                .onChange(of: email) { oldValue, newValue in
                    withAnimation {
                        isTextFieldFocused = false
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
        ForgotPasswordView()
    }
}
