//
//  DCAService.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-08-02.
//

import Foundation

struct DCAService {

    func calculate(
        initialInvestmentAmount: Double,
        monthlyDollarcostAveragingAmount: Double,
        initialDateOfInvestmentIndex: Int
    ) -> DCAResult {

        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, monthlyDollarcostAveragingAmount: monthlyDollarcostAveragingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        return .init(
            currentValue: 0,
            investmentAmount: investmentAmount,
            gain: 0,
            yeid: 0,
            annualReturn: 0
        )
    }

    private func getInvestmentAmount(
        initialInvestmentAmount: Double,
        monthlyDollarcostAveragingAmount: Double,
        initialDateOfInvestmentIndex: Int
    ) -> Double {
        var totalAmount = Double()

        let dollarCostAveragingAmounts = initialDateOfInvestmentIndex.doubleValue * monthlyDollarcostAveragingAmount

        totalAmount = dollarCostAveragingAmounts + initialInvestmentAmount

        return totalAmount
    }
}

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yeid: Double
    let annualReturn: Double
}
