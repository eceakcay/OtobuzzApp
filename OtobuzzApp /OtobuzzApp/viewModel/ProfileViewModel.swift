//
//  ProfileViewModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 30.05.2025.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User?

    func fetchUserProfile() {
        guard let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
              !userId.isEmpty else {
            print("❌ User ID bulunamadı veya boş")
            return
        }
        
        let urlString = "http://127.0.0.1:3000/api/users/\(userId)"
        guard let url = URL(string: urlString) else {
            print("❌ URL oluşturulamadı: \(urlString)")
            return
        }
        
        print("🌐 API çağrısı başlıyor → userId: \(userId)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ API hatası: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("❌ Data boş döndü")
                return
            }
            
            #if DEBUG
            print("📦 Gelen JSON: \(String(data: data, encoding: .utf8) ?? "Boş JSON")")
            #endif

            do {
                let fetchedUser = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    print("✅ Kullanıcı yüklendi: \(fetchedUser.ad), \(fetchedUser.email)")
                    self.user = fetchedUser
                }
            } catch {
                print("❌ JSON çözümleme hatası: \(error)")
            }
        }.resume()
    }
}
