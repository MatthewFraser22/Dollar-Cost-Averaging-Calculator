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
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!

    var asset: Asset?

    private var initialDateOfInvestmentIndex: Int?

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
        
        initialDateOfInvestmentTextField.delegate = self

        initialInvestment.addDoneButton()
        monthlyDollarCostAveragingAmount.addDoneButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDateSelection",
           let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionTableViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
            dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(index: index)
            }

        }
    }

    private func handleDateSelection(index: Int) {
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }

        navigationController?.popViewController(animated: true)
        if let monthInfos = asset?.timeSeriesMontlyAdjusted.getMonthInfos() {
            initialDateOfInvestmentIndex = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
}

extension CalculatorTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestmentTextField {
            performSegue(
                withIdentifier: "showDateSelection",
                sender: asset?.timeSeriesMontlyAdjusted
            )
            return false
        }

        return true
    }
}
