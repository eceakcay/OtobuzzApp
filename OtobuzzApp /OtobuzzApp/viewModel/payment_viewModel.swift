import Foundation

class PaymentViewModel: ObservableObject {
    @Published var cardNumber: String = ""
    @Published var expirationDate: String = ""
    @Published var cvv: String = ""
    @Published var paymentAmount: Double
    @Published var paymentStatus: String = ""
    @Published var paymentStarted: Bool = false
    
    let selectedSeat: BusJourneyListViewModel.Journey.Seat?
    
    init(journeyPrice: Double, selectedSeat: BusJourneyListViewModel.Journey.Seat?) {
        self.paymentAmount = journeyPrice
        self.selectedSeat = selectedSeat
    }
    
    func processPayment() -> Bool {
        if cardNumber.isEmpty || expirationDate.isEmpty || cvv.isEmpty {
            paymentStatus = "Lütfen tüm bilgileri doldurun."
            paymentStarted = true
            return false
        }
        
        if !isValidCardNumber(cardNumber) {
            paymentStatus = "Geçersiz kart numarası."
            paymentStarted = true
            return false
        }
        
        if !isValidExpirationDate(expirationDate) {
            paymentStatus = "Geçersiz son kullanma tarihi."
            paymentStarted = true
            return false
        }
        
        if !isValidCVV(cvv) {
            paymentStatus = "Geçersiz CVV."
            paymentStarted = true
            return false
        }
        
        paymentStarted = true
        paymentStatus = "Ödeme Başarılı! Koltuk: \(selectedSeat?.id ?? 0)"
        return true
    }
    
    // Kart numarasını 4’lü boşluklarla formatlar
    func formatCardNumber(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }
        var result = ""
        for (index, char) in digits.enumerated() {
            if index != 0 && index % 4 == 0 {
                result += " "
            }
            result.append(char)
        }
        return String(result.prefix(19)) // 16 rakam + 3 boşluk max
    }
    
    // Son kullanma tarihini MM/YY formatına dönüştürür
    func formatExpirationDate(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }
        var result = ""
        for (index, char) in digits.enumerated() {
            if index == 2 {
                result += "/"
            }
            if index >= 4 {
                break
            }
            result.append(char)
        }
        return result
    }
    
    // CVV sadece 3 rakam olmalı
    func isValidCVV(_ cvv: String) -> Bool {
        return cvv.count == 3 && cvv.allSatisfy({ $0.isNumber })
    }
    
    // Kart numarası (boşluk olmadan) 16 haneli rakam mı kontrol et
    func isValidCardNumber(_ number: String) -> Bool {
        let digits = number.filter { $0.isNumber }
        return digits.count == 16
    }
    
    // Son kullanma tarihi MM/YY formatı mı ve geçerli tarih mi kontrolü (basit kontrol)
    func isValidExpirationDate(_ date: String) -> Bool {
        let regex = "^\\d{2}/\\d{2}$"
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: date) else {
            return false
        }
        
        let components = date.split(separator: "/")
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]) else {
            return false
        }
        
        if month < 1 || month > 12 {
            return false
        }
        
        // Basit geçerlilik kontrolü (şu anki yılın son 2 hanesi)
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date()) % 100
        let currentMonth = calendar.component(.month, from: Date())
        
        if year < currentYear || (year == currentYear && month < currentMonth) {
            return false
        }
        
        return true
    }
    
    // Kullanıcının girdiği değerden sadece rakamları döner
    func filterInput(_ newValue: String) -> String {
        return newValue.filter { $0.isNumber }
    }
    
    func isPaymentSuccessful() -> Bool {
        return paymentStarted && paymentStatus.starts(with: "Ödeme Başarılı")
    }
}
