//
//  APIService.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-25.
//

import Foundation
import Combine

struct APIService {

    static let shared = APIService()

    var api_key: String {
        return keys.randomElement() ?? ""
    }

    let keys = ["XS68HMNMC352QQKS", "GJ6UNMV63AF85IDJ", "ATISWV6D9DFK3W0Y"]

    func fetchSymbolsPublisher(keyWords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keyWords)&apikey=\(api_key)"

        let url = URL(string: urlString)

        guard let url = url else {
            return Fail(
                error: NSError(domain: "Missing URL", code: -10001)
            ).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
