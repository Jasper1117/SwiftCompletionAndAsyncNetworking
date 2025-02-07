//
//  CoinAPIERROR.swift
//  SwiftCompletionAndAsyncNetworking
//
//  Created by Jasper Hui on 6/2/2025.
//

import Foundation

enum CoinAPIERROR: Error {
    case invaliData
    case jsonParsingFailure
    case requestFailed(description: String)
    case incaildStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invaliData:
            return "Data is invalid"
        case .jsonParsingFailure:
            return "JSON parsing failed"
        case .requestFailed(let description):
            return "Request failed: \(description)"
        case .incaildStatusCode(let statusCode):
            return "Invalid status code: \(statusCode)"
        case .unknownError(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
