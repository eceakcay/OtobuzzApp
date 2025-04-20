import SwiftUI

struct CitySelectionView: View {
    @State private var selectedCity = "İstanbul"
    let cities = ["İstanbul", "Ankara", "İzmir", "Bursa", "Antalya"]

    var body: some View {
        NavigationView {
            VStack {
                Text("Seçilen Şehir: \(selectedCity)")
                    .font(.title)
                    .padding()

                Form {
                    Section(header: Text("Şehir Seçimi")) {
                        Picker("Şehir", selection: $selectedCity) {
                            ForEach(cities, id: \.self) { city in
                                Text(city)
                            }
                        }
                        .pickerStyle(NavigationLinkPickerStyle())
                    }
                }
            }
            .navigationTitle("Şehir Seçimi")
        }
    }
}


