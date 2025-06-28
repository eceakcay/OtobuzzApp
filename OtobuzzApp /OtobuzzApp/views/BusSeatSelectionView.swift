//
//  BusSeatSelectionView.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 20.04.2025.
//

import SwiftUI

extension Notification.Name {
    static let refreshJourneys = Notification.Name("refreshJourneys")
}

struct BusSeatSelectionView: View {
    let journey: BusJourneyListViewModel.Journey
    @Environment(\.dismiss) var dismiss
    @State private var isPaymentViewActive = false
    @State private var selectedSeat: BusJourneyListViewModel.Journey.Seat?
    @State private var showAlert = false

    private var occupiedCount: Int {
        journey.seats.filter { $0.isOccupied }.count
    }

    private var femaleCount: Int {
        journey.seats.filter { $0.isOccupied && $0.gender == .female }.count
    }

    private var maleCount: Int {
        journey.seats.filter { $0.isOccupied && $0.gender == .male }.count
    }

    private var totalSeats: Int {
        journey.seats.filter { $0.id != 0 }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                VStack(spacing: 20) {
                    headerView
                    seatGridView
                    occupancySummaryView
                    paymentButtonView
                }
                .padding(.vertical, 20)
                .background(contentBackground)
                .padding(.horizontal, 20)
                .navigationDestination(isPresented: $isPaymentViewActive) {
                    Payment(journeyPrice: journey.price, selectedSeat: selectedSeat)
                }
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.orange.opacity(0.05), .white]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Otobüs Koltuk Düzeni")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.orange)

            Text("\(journey.companyName) - \(journey.departureTime)")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.gray.opacity(0.8))
        }
    }

    private var seatGridView: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<journey.seats.count / 4, id: \.self) { rowIndex in
                    HStack(spacing: 16) {
                        SeatView(seat: journey.seats[rowIndex * 4], selectedSeat: $selectedSeat)
                        SeatView(seat: journey.seats[rowIndex * 4 + 1], selectedSeat: $selectedSeat)

                        Spacer().frame(width: 40)

                        SeatView(seat: journey.seats[rowIndex * 4 + 3], selectedSeat: $selectedSeat)
                    }
                }
            }
            .padding()
        }
    }

    private var occupancySummaryView: some View {
        VStack(spacing: 8) {
            Text("Doluluk: \(occupiedCount)/\(totalSeats)")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.black)

            Text("Kadın: \(femaleCount) | Erkek: \(maleCount)")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.gray)

            if let selected = selectedSeat {
                Text("Seçilen Koltuk: \(selected.id) (\(selected.gender == .female ? "Kadın" : "Erkek"))")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 10)
    }

    private var paymentButtonView: some View {
        Button(action: {
            guard let selected = selectedSeat else {
                showAlert = true
                return
            }

            let genderString = selected.gender == .female ? "Kadın" : "Erkek"

            APIService.shared.updateSeat(for: journey.id, seatNumber: selected.id, gender: genderString) { result in
                switch result {
                case .success(let updatedTrip):
                    print("✅ Güncellenen koltuklar: \(updatedTrip.koltuklar)")

                    APIService.shared.getTripDetail(tripId: journey.id) { detailResult in
                        switch detailResult {
                        case .success(let tripDetail):
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: .refreshJourneys, object: nil)
                                isPaymentViewActive = true
                            }
                        case .failure(let error):
                            print("❌ Detay güncellenemedi: \(error)")
                        }
                    }

                case .failure(let error):
                    print("❌ Koltuk güncelleme hatası: \(error)")
                }
            }

        }) {
            Text("Ödeme Sayfasına Git")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(buttonGradient)
                .cornerRadius(12)
                .shadow(color: .orange.opacity(0.2), radius: 2)
        }
        .padding(.horizontal, 40)
        .alert("Koltuk Seçimi", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("Lütfen ödeme yapmadan önce bir koltuk seçin.")
        }
    }

    private var buttonGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var contentBackground: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.orange.opacity(0.2), lineWidth: 1)
            )
    }
}

// MARK: - SeatView

struct SeatView: View {
    let seat: BusJourneyListViewModel.Journey.Seat
    @Binding var selectedSeat: BusJourneyListViewModel.Journey.Seat?
    @State private var showGenderSelection = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(seatColor)
                .frame(width: 40, height: 40)

            Text("\(seat.id)")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white)
        }
        .onTapGesture {
            if !seat.isOccupied {
                selectedSeat = seat
                showGenderSelection = true
            }
        }
        .sheet(isPresented: $showGenderSelection) {
            GenderSelectionView(seat: seat, selectedSeat: $selectedSeat)
        }
    }

    private var seatColor: Color {
        if seat.isOccupied {
            return seat.gender == .female ? .pink : .blue
        } else {
            return selectedSeat?.id == seat.id ? .green : .gray.opacity(0.3)
        }
    }
}

// MARK: - GenderSelectionView

struct GenderSelectionView: View {
    let seat: BusJourneyListViewModel.Journey.Seat
    @Binding var selectedSeat: BusJourneyListViewModel.Journey.Seat?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Cinsiyet Seçiniz")
                .font(.headline)

            HStack(spacing: 20) {
                Button("Kadın") {
                    selectedSeat = BusJourneyListViewModel.Journey.Seat(id: seat.id, isOccupied: true, gender: .female)
                    dismiss()
                }
                .padding()
                .background(Color.pink.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)

                Button("Erkek") {
                    selectedSeat = BusJourneyListViewModel.Journey.Seat(id: seat.id, isOccupied: true, gender: .male)
                    dismiss()
                }
                .padding()
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
            }

            Button("İptal") {
                dismiss()
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
        )
        .padding()
    }
}
