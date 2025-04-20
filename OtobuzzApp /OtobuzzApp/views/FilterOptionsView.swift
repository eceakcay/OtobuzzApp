//
//  FilterOptionsView.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 20.04.2025.
//

import SwiftUI

struct FilterOptionsView: View {
    @ObservedObject var viewModel: BusJourneyListViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Saat Aralığı Bölümü
                    Text("Saat Aralığı")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        FilterButton(title: "00:00 - 06:00") {
                            viewModel.filterByTimeRange(startHour: 0, endHour: 6)
                            viewModel.showingFilterOptions = false
                        }
                        FilterButton(title: "06:00 - 12:00") {
                            viewModel.filterByTimeRange(startHour: 6, endHour: 12)
                            viewModel.showingFilterOptions = false
                        }
                        FilterButton(title: "12:00 - 18:00") {
                            viewModel.filterByTimeRange(startHour: 12, endHour: 18)
                            viewModel.showingFilterOptions = false
                        }
                        FilterButton(title: "18:00 - 24:00") {
                            viewModel.filterByTimeRange(startHour: 18, endHour: 24)
                            viewModel.showingFilterOptions = false
                        }
                    }
                    
                    // Firma Bölümü
                    Text("Firma")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        FilterButton(title: "EROVA") {
                            viewModel.filterByCompany("EROVA")
                            viewModel.showingFilterOptions = false
                        }
                        FilterButton(title: "Isparta Petrol") {
                            viewModel.filterByCompany("Isparto")
                            viewModel.showingFilterOptions = false
                        }
                        FilterButton(title: "Pamukkale") {
                            viewModel.filterByCompany("Pamukkale")
                            viewModel.showingFilterOptions = false
                        }
                    }

                    // Tüm Filtreleri Temizle
                    FilterButton(title: "Tüm Filtreleri Temizle", isDestructive: true) {
                        viewModel.resetFilters()
                        viewModel.showingFilterOptions = false
                    }

                    // Kapat Butonu
                    Button("Kapat") {
                        viewModel.showingFilterOptions = false
                    }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                .padding()
            }
        }
    }
}

struct FilterButton: View {
    let title: String
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: isDestructive ? [.main.opacity(0.8), .red] : [.main, .orange.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(15)
                .shadow(color: .orange.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    FilterOptionsView(viewModel: BusJourneyListViewModel(homeViewModel: HomeViewModel()))
}


