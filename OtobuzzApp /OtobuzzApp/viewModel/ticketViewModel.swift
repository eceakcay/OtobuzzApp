//
//  ticketViewModel.swift
//  OtobuzzApp
//
//  Created by Mine Kırmacı on 28.06.2025.
//


import Foundation
import Combine

class TicketsViewModel: ObservableObject {
    @Published var tickets: [TicketModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchTickets(for userId: String) {
        isLoading = true
        errorMessage = nil

        APIService.shared.get(endpoint: "tickets/user/\(userId)", responseType: [TicketModel].self) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.tickets = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
