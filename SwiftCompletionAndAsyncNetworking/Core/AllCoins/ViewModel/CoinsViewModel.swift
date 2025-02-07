//
//  CoinsViewModel.swift
//  SwiftCompletionAndAsyncNetworking
//
//  Created by Jasper Hui on 6/2/2025.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    private var service = CoinDataService()
    
    init(coin: String = "", price: String = "") {
       
        fetchCoins()
    }
    
    func fetchCoins() {
        Task {
            let coins = try await service.fetchCoinsWithAsync()
            await MainActor.run {
                self.coins = coins
            }
        }
    }
    
    func fetchCoinsWithCompletionHandler() {
//        service.fetchCoins { coins, error in
//            // update the UI on the main thread
//            DispatchQueue.main.async {
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                self.coins = coins ?? []
//            }
//        }
        
        // weak self to avoid retain cycle
        service.fetchCoinsWithResult{ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let coins):
                        self?.coins = coins
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}
