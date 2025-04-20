import Foundation

class PaymentViewModel: ObservableObject {
    @Published var cardNumber: String = ""
    @Published var expirationDate: String = ""
    @Published var cvv: String = ""
    @Published var paymentAmount: Double
    @Published var paymentStatus: String = ""
    @Published var paymentStarted: Bool = false
    
    private let selectedSeat: BusJourneyListViewModel.Journey.Seat?
    
    // Formatlanmış ödeme miktarı (UI için)
    var formattedPaymentAmount: String {
        return String(format: "%.2f TL", paymentAmount)
    }
    
    init(journeyPrice: Double, selectedSeat: BusJourneyListViewModel.Journey.Seat?) {
        self.paymentAmount = journeyPrice
        self.selectedSeat = selectedSeat
    }
    
    // Ödeme işlemini gerçekleştirecek fonksiyon
    func processPayment() {
        // Kart numarası, son kullanma tarihi ve CVV kontrolü
        if cardNumber.isEmpty || expirationDate.isEmpty || cvv.isEmpty {
            paymentStatus = "Lütfen tüm bilgileri doldurun."
            paymentStarted = true
            return
        }
        
        if !isValidCardNumber(cardNumber) {
            paymentStatus = "Geçersiz kart numarası."
            paymentStarted = true
            return
        }
        
        if !isValidExpirationDate(expirationDate) {
            paymentStatus = "Geçersiz son kullanma tarihi."
            paymentStarted = true
            return
        }
        
        if !isValidCVV(cvv) {
            paymentStatus = "Geçersiz CVV."
            paymentStarted = true
            return
        }
        
        // Ödeme işlemi simülasyonu
        paymentStarted = true
        paymentStatus = "Ödeme Başarılı! Koltuk: \(selectedSeat?.id ?? 0)"
    }
    
    // Kart numarasını geçerli formatta kontrol et (boşluksuz 16 haneli sayı)
    private func isValidCardNumber(_ number: String) -> Bool {
        let regex = "^\\d{16}$" // 16 tane rakam, boşluksuz
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: number)
    }
    
    // Son kullanma tarihini geçerli formatta kontrol et (MMYY formatı, 4 haneli, örneğin: 1125)
    private func isValidExpirationDate(_ date: String) -> Bool {
        let regex = "^\\d{4}$" // 4 tane rakam, "/" yok
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: date)
    }
    
    // CVV geçerliliğini kontrol et
    private func isValidCVV(_ cvv: String) -> Bool {
        return cvv.count == 3
    }
    
    // Kullanıcının girdiği değeri yalnızca sayılara indirgeme
    func filterInput(_ newValue: String) -> String {
        return newValue.filter { $0.isNumber }
    }
    
    // Ödeme durumu kontrolü - View'de gösterilecek durumu döner
    func isPaymentSuccessful() -> Bool {
        return paymentStarted && paymentStatus == "Ödeme Başarılı! Koltuk: \(selectedSeat?.id ?? 0)"
    }
}
