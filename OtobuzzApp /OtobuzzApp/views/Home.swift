import SwiftUI

struct Home: View {
    @StateObject private var viewModel = HomeViewModel() // StateObject olmalı
    @State private var selectedTab: String = "Ara"
    @State private var navigateToList = false

    var body: some View {
        NavigationStack {
            VStack {
                CustomAppBar()
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 2)
                    .frame(width: 350, height: 220)
                    .padding()
                    .overlay(
                        ZStack {
                            Image("konum")
                                .padding(.leading, 190)

                            VStack(alignment: .leading) {
                                Text("NEREDEN")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.main)
                                    .padding(.top, 10)
                                    .padding(.leading, 20)

                                Picker("Şehir Seç", selection: $viewModel.nereden) {
                                    ForEach(viewModel.cities, id: \.self) { city in
                                        Text(city)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: 120)
                                .cornerRadius(8)

                                Text("NEREYE")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.main)
                                    .padding(.top, 40)
                                    .padding(.leading, 20)

                                Picker("Şehir Seç", selection: $viewModel.nereye) {
                                    ForEach(viewModel.cities, id: \.self) { city in
                                        Text(city)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: 120)
                                .cornerRadius(8)
                            }
                            .padding(.trailing, 130)
                        }
                    )

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 2)
                    .frame(width: 350, height: 130)
                    .padding()
                    .overlay(
                        VStack(alignment: .leading) {
                            Text("GİDİŞ TARİHİ")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.main)
                                .padding(.trailing, 90)
                                .padding(.bottom, 20)

                            DatePicker("Tarihi Seç", selection: $viewModel.selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .frame(maxWidth: 205)
                                .padding(.leading, 20)
                                .background(Color.white)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                                .shadow(radius: 2)
                        }
                    )

                Button(action: {
                    navigateToList = true
                }) {
                    Text("Otobüs Ara")
                        .padding()
                        .frame(width: 270, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 15)
                }

                NavigationLink(
                    destination: BusJourneyListView(viewModel: BusJourneyListViewModel(homeViewModel: viewModel)),
                    isActive: $navigateToList
                ) {
                    EmptyView()
                }

                CustomNavigationBar(selectedTab: $selectedTab)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    Home()
}
