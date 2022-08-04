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
        let result = parseQuery(text: keyWords)

        var symbol = String()

        switch result {
        case .success(let query):
            symbol = query
        case let .failure(error):
            return Fail(error: error).eraseToAnyPublisher()
        }

        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(api_key)"

        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
        case.success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: SearchResults.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case let .failure(error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func fetchTimeSeriesMonthlyAdjustedPublisher(keywords: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {

        let result = parseQuery(text: keywords)

        var symbol = String()

        switch result {
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }

//        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
//            return Fail(error: ApiError.encodingError).eraseToAnyPublisher()
//        }

        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(api_key)"

        let urlResult = parseURL(urlString: urlString)

        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case let .failure(error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    private func parseQuery(text: String) -> Result<String, Error> {
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return .success(query)
        } else {
            return .failure(ApiError.encodingError)
        }
    }

    private func parseURL(urlString: String) -> Result<URL, Error> {

        guard let url = URL(string: urlString) else { return .failure(ApiError.invalidURL) }

        return .success(url)
    }
}

/*
 func fetchSymbolsPublisher(keyWords: String) -> AnyPublisher<SearchResults, Error> {
     let result = parseQuery(text: keyWords)

     var symbol = String()

     switch result {
     case .success(let query):
         symbol = query
     case let .failure(error):
         return Fail(error: error).eraseToAnyPublisher()
     }

     let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(api_key)"

     let url = URL(string: urlString)

     guard let url = url else {
         return Fail(error: ApiError.invalidURL).eraseToAnyPublisher()
     }

     return URLSession.shared.dataTaskPublisher(for: url)
         .map { $0.data }
         .decode(type: SearchResults.self, decoder: JSONDecoder())
         .receive(on: RunLoop.main)
         .eraseToAnyPublisher()
 }
 */
