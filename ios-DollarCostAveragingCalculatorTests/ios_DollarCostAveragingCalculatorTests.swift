//
//  ios_DollarCostAveragingCalculatorTests.swift
//  ios-DollarCostAveragingCalculatorTests
//
//  Created by Matthew Fraser on 2022-08-03.
//

import XCTest
@testable import ios_DollarCostAveragingCalculator

class ios_DollarCostAveragingCalculatorTests: XCTestCase {

    var sut: DCAService! // sut = System under test

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()

        sut = nil // so we dont keep states
    }

    /* FORMAT FOR TEST FUNCTION NAME
     1. WAHT
     2. GIVEN
     3. EXPECTATION
     */

    func test_DCAResult_givenDollarCostAveragingIsUsed_expectResult() {
        
    }

    func test_DCAResult_givenDollarCostAveragingIsNotUsed_expectResult() {
        
    }

    func test_InvestmentAmount_whenDCAIsUsed_expectResult() {
        // given
        let initialInvestmentAmount = 500.0
        let monthlyDollarCostAveragingAmount = 100.0
        let initialDateOfInvestmentIndex = 4 // (5 months ago)
    
        // when
        let investmentAmount = sut.getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarcostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex
        )

        // then
        XCTAssertEqual(investmentAmount, 900)
    }

    func test_InvestmentAmount_whenDCAIsNotUsed_expectResult() {
        // given
        let initialInvestmentAmount = 500.0
        let monthlyDollarCostAveragingAmount = 0.0
        let initialDateOfInvestmentIndex = 4 // (5 months ago)

        // when
        let investmentAmount = sut.getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarcostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex
        )

        // then
        XCTAssertEqual(investmentAmount, 500)
    }

    func test_Result_givenWinningAssetAndDCAIsUsed_expectPositiveGains() {
        // given
        let initInvestmentAmount: Double = 5000
        let monthlyDollarCostAveraging: Double = 1500
        let initDateOfInvestmentIndex = 5 // 6 months ago
        let asset = buildWinningAsset()

        // when
        let result = sut.calculate(
            asset: asset,
            initialInvestmentAmount: initInvestmentAmount,
            monthlyDollarcostAveragingAmount: monthlyDollarCostAveraging,
            initialDateOfInvestmentIndex: initDateOfInvestmentIndex
        )
        // then
        
        // Initial investment: $5000
        // DCA: $1500 X 5 = $7500
        // total: $5000 + $7500 = $12500
        XCTAssertEqual(result.investmentAmount, 12500, "Investment amount is incorrect")
        XCTAssertTrue(result.isProfitable)

        
        // Jan: $5000 / 100 = 50 shares
        // Feb: $1500 / 110 = 13.6363 shares
        // March: $1500 / 120 = 12.5 shares
        // April: $1500 / 130 = 11.5384 shares
        // May: $1500 / 140 = 10.7142 shares
        // June: $1500 / 150 = 10 shares
        // Total shares = 108.3889 shares
        // Total current value = 108.3889 X $160 (latest month closing price) = $17,342.224
        XCTAssertEqual(result.currentValue, 17342.224, accuracy: 0.1)
        
        // gain = currentValue - totalInvestment
        // gain = 17342.224 - 12500
        XCTAssertEqual(result.gain, 4842.224, accuracy: 0.1)
        
        // yeild = percentage of gain
        // yeid = 4842.224 / 12500
        XCTAssertEqual(result.yeid, 0.3873, accuracy: 0.0001)
    }

    func test_Result_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        
    }

    func test_Result_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        
    }

    func test_Result_givenLosingAssetAndDCAIsNotUsed_expectPositiveGains() {
        
    }

    //
    // MARK: Helper Functions
    //

    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries: [String : OHLC] = [
            "2021-01-25": OHLC(open: "100", close: "110", adjustedClose: "110"),
            "2021-02-25": OHLC(open: "110", close: "120", adjustedClose: "120"),
            "2021-03-25": OHLC(open: "120", close: "130", adjustedClose: "130"),
            "2021-04-25": OHLC(open: "130", close: "140", adjustedClose: "140"),
            "2021-05-25": OHLC(open: "140", close: "150", adjustedClose: "150"),
            "2021-06-25": OHLC(open: "150", close: "160", adjustedClose: "160")
        ]
        let tsma = TimeSeriesMonthlyAdjusted(
            meta: meta,
            timeSeries: timeSeries
        )

        return Asset(
            searchResult: searchResult,
            timeSeriesMontlyAdjusted: tsma
        )
    }
    
    private func buildSearchResult() -> SearchResult {
        return SearchResult(
            symbol: "XYZ",
            currency: "USD",
            name: "XYZ Company",
            type: "ETF"
        )
    }
    
    private func buildMeta() -> Meta {
        return Meta(symbol: "XYZ")
    }

    //
    //
    //
    // MARK: Example Tests
    //
    //
    //

    func Example() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.

        // Given
        let num1 = 1
        let num2 = 2

        // When
        let result = addTwoValues(value1: num1, value2: num2)

        // Then
        XCTAssertEqual(2, result)
    }

    func PerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func Example2() {
        let result = addTwoValues(value1: 1, value2: 1)

        XCTAssertEqual(2, result)
    }

    func addTwoValues(value1: Int, value2: Int) -> Int {
        return value1 + value2
    }
}
