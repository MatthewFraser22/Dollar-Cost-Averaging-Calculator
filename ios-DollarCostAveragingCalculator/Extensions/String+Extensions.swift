//
//  String+Extensions.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-27.
//

import Foundation

extension String {
    func addBrackets() -> String {
        return "(\(self))"
    }

    func prefix(withText text: String) -> String {
        return text + self
    }

    var toDouble: Double? {
        return Double(self)
    }
}
