//
//  DCAService.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-08-02.
//

import Foundation

struct DCAService {

    func calculate(
        asset: Asset,
        initialInvestmentAmount: Double,
        monthlyDollarcostAveragingAmount: Double,
        initialDateOfInvestmentIndex: Int
    ) -> DCAResult {

        let investmentAmount = getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarcostAveragingAmount: monthlyDollarcostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex
        )

        // currentValue = numberOfShares(initialInvestment + DCA) * latestSharePrice
        let latestSharePrice = getLatestSharePrice(asset: asset)
        let numberOfShares = getNumberOfShares(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarcostAveragingAmount: monthlyDollarcostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex
        )
        let currentValue = getCurrentValue(
            numberOfShares: numberOfShares,
            latestSharePrice: latestSharePrice
        )

        let isProfitable = currentValue > investmentAmount

        // gain is profit
        let gain = currentValue - investmentAmount

        // yeid is percentage if gains
        // example
        // investmentAmount: $10,000
        // currentValue: $12,000
        // gain: +$2000
        // yeild: $2000 / $10,000 = 20%

        let yeild = gain / investmentAmount
        let annualReturn = getAnnualReturn(currentValue: currentValue, investmentAmount: investmentAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        return .init(
            currentValue: currentValue,
            investmentAmount: investmentAmount,
            gain: gain,
            yeid: yeild,
            annualReturn: annualReturn,
            isProfitable: isProfitable
        )
    }

    func getAnnualReturn(
        currentValue: Double,
        investmentAmount: Double,
        initialDateOfInvestmentIndex: Int
    ) -> Double {
        let rate = currentValue / investmentAmount
        let years = ((initialDateOfInvestmentIndex.doubleValue + 1) / 12)

        return pow(rate, (1/years)) - 1
    }

    func getInvestmentAmount(
        initialInvestmentAmount: Double,
        monthlyDollarcostAveragingAmount: Double,
        initialDateOfInvestmentIndex: Int
    ) -> Double {
        var totalAmount = Double()

        totalAmount += initialInvestmentAmount
        
        print("Testing initialdate of investment index \(initialDateOfInvestmentIndex.doubleValue) * \(monthlyDollarcostAveragingAmount)")
        let dollarCostAveragingAmounts = initialDateOfInvestmentIndex.doubleValue * monthlyDollarcostAveragingAmount

        totalAmount += dollarCostAveragingAmounts

        print("TESTING investmentAmount \(totalAmount) inventAmt: \(initialInvestmentAmount) dca\(dollarCostAveragingAmounts)")
        return totalAmount
    }

    func getCurrentValue(numberOfShares: Double, latestSharePrice: Double) -> Double {
        return numberOfShares * latestSharePrice
    }

    func getLatestSharePrice(asset: Asset) -> Double {
        return asset.timeSeriesMontlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
    }

    func getNumberOfShares(
        asset: Asset,
        initialInvestmentAmount: Double,
        monthlyDollarcostAveragingAmount: Double,
        initialDateOfInvestmentIndex: Int
    ) -> Double {
        var totalShares = Double()

        let initialInvestmentOpenPrice = asset.timeSeriesMontlyAdjusted.getMonthInfos()[initialDateOfInvestmentIndex].adjustedOpen
        // 100 correct

        let initalInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initalInvestmentShares
        
        print("TESTING total shares amount: \(initialInvestmentAmount) : open$ \(initialInvestmentOpenPrice)")
        asset.timeSeriesMontlyAdjusted.getMonthInfos().prefix(initialDateOfInvestmentIndex).forEach { monthInfo in
            let dcaInvestmentShares = monthlyDollarcostAveragingAmount / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        
        
        return totalShares
    }
}

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yeid: Double
    let annualReturn: Double
    let isProfitable: Bool
}
