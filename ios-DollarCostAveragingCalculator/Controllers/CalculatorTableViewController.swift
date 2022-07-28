//
//  CalculatorTableViewController.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-27.
//

import Foundation
import UIKit

class CalculatorTableViewController: UITableViewController {

    // MARK: IBOutlets

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var initialInvestment: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingAmount: UITextField!

    var asset: Asset?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTextViews()
    }

    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        assetNameLabel.text = asset?.searchResult.name
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        currencyLabels.forEach { label in
            label.text = asset?.searchResult.currency.addBrackets()
        }
        tableView.allowsSelection = false
    }

    private func setupTextViews() {
        initialInvestment.keyboardType = .numberPad
        monthlyDollarCostAveragingAmount.keyboardType = .numberPad

        initialInvestment.addDoneButton()
        monthlyDollarCostAveragingAmount.addDoneButton()
    }

}
