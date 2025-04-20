import SwiftUI

struct Home: View {
    @ObservedObject private var viewModel = HomeViewModel()
    @State private var selectedTab: String = "Ara"
    @State private var busJourneyViewModel = BusJourneyListViewModel(homeViewModel: HomeViewModel())


    var body: some View {
        NavigationStack {
            VStack {
                CustomAppBar()
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(1))
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
                    .fill(Color.white.opacity(1))
                    .shadow(radius: 2)
                    .frame(width: 350, height: 130)
                    .padding()
                    .overlay(
                        ZStack {
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

                            }})

                NavigationLink(destination: BusJourneyListView(viewModel: busJourneyViewModel)) {
                    Button("Otobüs Ara") {
                    }
                    .padding()
                    .frame(width: 270, height: 50)
                    .background(Color.blue.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 15)
                }

                CustomNavigationBar(selectedTab: $selectedTab)             }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    Home()
}
