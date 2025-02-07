//
//  Coin.swift
//  SwiftCompletionAndAsyncNetworking
//
//  Created by Jasper Hui on 6/2/2025.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    
    // CodingKeys to match the JSON keys
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}
