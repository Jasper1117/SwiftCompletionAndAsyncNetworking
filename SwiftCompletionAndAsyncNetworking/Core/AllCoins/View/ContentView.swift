//
//  ContentView.swift
//  SwiftCompletionAndAsyncNetworking
//
//  Created by Jasper Hui on 6/2/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
        List{
            ForEach(viewModel.coins){ coin in
                HStack{
                    Text("\(coin.marketCapRank)")
                        .foregroundStyle(.gray)
                    VStack(alignment: .leading){
                        Text(coin.name).fontWeight(.semibold)
                        
                        Text(coin.symbol)
                    }
                }.font(.footnote)
            }
        }
        .overlay {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
