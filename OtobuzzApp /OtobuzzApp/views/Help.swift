import SwiftUI

struct Help: View {
    @State private var faqExpanded = Array(repeating: false, count: 3)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sık Sorulan Sorular")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.main) // Apply main color
                        .padding(.bottom)

                    DisclosureGroup(
                        isExpanded: $faqExpanded[0],
                        content: {
                            Text("Otobüs saatleri şehir seçimine göre gösterilmektedir. Ana sayfada şehir seçerek saatleri görebilirsiniz.")
                                .padding(.top, 4)
                                .foregroundColor(.gray) // Change content text color
                        },
                        label: {
                            Text("Otobüs saatlerini nereden görebilirim?")
                                .fontWeight(.medium)
                                .foregroundColor(.main) // Label text color
                        }
                    )
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))

                    DisclosureGroup(
                        isExpanded: $faqExpanded[1],
                        content: {
                            Text("Uygulama üzerinden ödeme yaptıktan sonra biletinize 'Profilim > Satın Alınan Biletler' kısmından ulaşabilirsiniz.")
                                .padding(.top, 4)
                                .foregroundColor(.gray)
                        },
                        label: {
                            Text("Biletimi nerede bulabilirim?")
                                .fontWeight(.medium)
                                .foregroundColor(.main)
                        }
                    )
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))

                    DisclosureGroup(
                        isExpanded: $faqExpanded[2],
                        content: {
                            Text("Profil sayfanızdaki 'Ayarlar' kısmından ad, soyad ve e-posta gibi bilgilerinizi güncelleyebilirsiniz.")
                                .padding(.top, 4)
                                .foregroundColor(.gray)
                        },
                        label: {
                            Text("Kullanıcı bilgilerimi nasıl güncellerim?")
                                .fontWeight(.medium)
                                .foregroundColor(.main)
                        }
                    )
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))
                }
                .padding()
            }
            .navigationTitle("Yardım")
            .background(LinearGradient(gradient: Gradient(colors: [.orange.opacity(0.05), .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
}

#Preview {
    Help()
}
