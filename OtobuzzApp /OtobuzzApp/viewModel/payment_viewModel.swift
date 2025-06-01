import Foundation

class PaymentViewModel: ObservableObject {
    @Published var cardNumber: String = ""
    @Published var expirationDate: String = ""
    @Published var cvv: String = ""
    @Published var paymentAmount: Double
    @Published var paymentStatus: String = ""
    @Published var paymentStarted: Bool = false
    
    private let selectedSeat: BusJourneyListViewModel.Journey.Seat?
    var userId: String
    var tripId: String
    
    // Formatlanmış ödeme miktarı (UI için)
    var formattedPaymentAmount: String {
        return String(format: "%.2f TL", paymentAmount)
    }
    
    init(journeyPrice: Double, selectedSeat: BusJourneyListViewModel.Journey.Seat?, userId: String, tripId: String) {
        self.paymentAmount = journeyPrice
        self.selectedSeat = selectedSeat
        self.userId = userId
        self.tripId = tripId
    }
    
    // Ödeme işlemini gerçekleştirecek fonksiyon
    func processPayment() {
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

        paymentStarted = true
        paymentStatus = "Ödeme Başarılı! Koltuk: \(selectedSeat?.id ?? 0)"

        // ✅ Ödeme başarılı, backend'e ticket gönder
        guard let seat = selectedSeat else { return }

        let ticket = TicketRequest(
            userId: userId,
            tripId: tripId,
            koltukNo: seat.id,
            cinsiyet: seat.gender == .female ? "Kadın" : "Erkek",
            odemeDurumu: "Odendi",
            onay: true
        )

        APIService.shared.createTicket(ticket: ticket) { success in
            DispatchQueue.main.async {
                if success {
                    print("🎫 Bilet backend'e başarıyla kaydedildi.")
                } else {
                    print("❌ Bilet gönderimi başarısız.")
                }
            }
        }
    }

    // Kart numarasını geçerli formatta kontrol et (boşluksuz 16 haneli sayı)
    private func isValidCardNumber(_ number: String) -> Bool {
        let regex = "^\\d{16}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: number)
    }
    
    // Son kullanma tarihini geçerli formatta kontrol et (MMYY formatı, 4 haneli)
    private func isValidExpirationDate(_ date: String) -> Bool {
        let regex = "^\\d{4}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: date)
    }
    
    // CVV geçerliliğini kontrol et
    private func isValidCVV(_ cvv: String) -> Bool {
        return cvv.count == 3 && cvv.allSatisfy { $0.isNumber }
    }
    
    func setUserId(_ id: String) {
        self.userId = id
    }

    // Kullanıcının girdiği değeri yalnızca sayılara indirgeme
    func filterInput(_ newValue: String) -> String {
        return newValue.filter { $0.isNumber }
    }
    
    // Ödeme durumu kontrolü - View'de gösterilecek durumu döner
    func isPaymentSuccessful() -> Bool {
        return paymentStarted && paymentStatus.contains("Ödeme Başarılı")
    }
}
