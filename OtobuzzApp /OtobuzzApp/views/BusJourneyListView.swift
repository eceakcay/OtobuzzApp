//
//  BusJourneyListView.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 20.04.2025.
//

import SwiftUI

struct BusJourneyListView: View {
    @ObservedObject var viewModel: BusJourneyListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.orange.opacity(0.05), .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Sırala ve Filtrele Butonları
                    HStack {
                        Button(action: {
                            viewModel.showingSortOptions = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.up.arrow.down")
                                Text("Sırala")
                            }
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(10)
                            .shadow(color: .orange.opacity(0.2), radius: 2)
                        }
                        .sheet(isPresented: $viewModel.showingSortOptions) {
                            SortOptionsView(viewModel: viewModel)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.showingFilterOptions = true
                        }) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                Text("Filtrele")
                            }
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(10)
                            .shadow(color: .orange.opacity(0.2), radius: 2)
                        }
                        .sheet(isPresented: $viewModel.showingFilterOptions) {
                            FilterOptionsView(viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    .background(Color.white)
                    
                    // Başlık ve Tarih Navigasyonu
                    VStack {
                        Text("\(viewModel.homeViewModel.nereden) → \(viewModel.homeViewModel.nereye)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 10)
                        
                        HStack {
                            Button(action: {
                                viewModel.previousDay()
                            }) {
                                Text("Önceki")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.7))
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                            
                            Text(viewModel.formatDate(viewModel.currentDate))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.nextDay()
                            }) {
                                Text("Sonraki")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.7))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .background(Color.white)
                    
                    // Sefer Listesi
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.journeys) { journey in
                                JourneyCard(journey: journey, from: viewModel.homeViewModel.nereden, to: viewModel.homeViewModel.nereye)
                                    .environmentObject(viewModel)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                    }
                    .background(Color.gray.opacity(0.05))
                }
            }
            .sheet(isPresented: $viewModel.showingSeatSelection) {
                if let selectedJourney = viewModel.selectedJourney {
                    BusSeatSelectionView(journey: selectedJourney)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    let homeViewModel = HomeViewModel()
    homeViewModel.nereden = "İstanbul"
    homeViewModel.nereye = "Ankara"
    homeViewModel.selectedDate = Date()
    return BusJourneyListView(viewModel: BusJourneyListViewModel(homeViewModel: homeViewModel))
}

