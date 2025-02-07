//
//  CoinDataService.swift
//  SwiftCompletionAndAsyncNetworking
//
//  Created by Jasper Hui on 6/2/2025.
//

import Foundation

class CoinDataService{
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&price_change_percentage=1h"
    
    func fetchCoinsWithAsync() async throws -> [Coin]{
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            return coins
        } catch {
            print("Error: \(error.localizedDescription)")
            return []
        }

    }
  
}


// MAKR: - Completion Handler
extension CoinDataService{
    // using Result to fetch data from an API
    func fetchCoinsWithResult(completion: @escaping (Result<[Coin], CoinAPIERROR>)->Void){
       guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "response is invalid")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.incaildStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invaliData))
                return }
            
            do {
                // decode the data into an array of Coin objects
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("Failed to decode with error: \(error)")
                completion(.failure(.jsonParsingFailure))
            }
           
        }.resume()
    }
    
    
    // optional completion to fetching data from an API (not recommended)
    func fetchCoins(completion: @escaping ([Coin]?, Error?)->Void){
       guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            guard let data = data else { return }
            // decode the data into an array of Coin objects
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                print("Failed to decode JSON")
                return
            }

            completion(coins, nil)
        }.resume()
    }
    
    
    // traditional way with completion to fetching data from an API
    func fetchPrice(coin: String, completion: @escaping (Double)->Void ){
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
    
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

                if let error = error {
                    print("Error: \(error.localizedDescription)")
//                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
//                    self.errorMessage = "Invalid response"
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
//                    self.errorMessage = "Failed to fetch with status code: \(httpResponse.statusCode)"
                    return
                }
                
                // make sure we have data
                guard let data = data else { return }
                // serialize the data, convert it to JSON and store it in as a  dictionary(key value pair)
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                // get the value of the key "bitcoin" and store it in a dictionary
                guard let value = jsonObject[coin] as? [String: Double] else { return }
                guard let price = value["usd"] else { return }
               
//                self.coin =  coin.capitalized
//                self.price = "$\(price)"
                completion(price)
            
        }.resume()
    }
}
