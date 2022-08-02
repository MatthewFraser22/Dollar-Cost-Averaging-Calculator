//
//  CalculatorTableViewController.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-27.
//

import Foundation
import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {

    // MARK: IBOutlets

    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var investmentAmountLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yeildLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var initialInvestment: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingAmount: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet weak var dateSlider: UISlider!

    var asset: Asset?

    @Published private var initialDateOfInvestmentIndex: Int?
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDollarCostAveraging: Int?

    private var subscribers = Set<AnyCancellable>()
    private let dcaService = DCAService()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTextViews()
        setupDateSlider()
        observeFourm()
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

    private func setupDateSlider() {
        if let count = asset?.timeSeriesMontlyAdjusted.getMonthInfos().count {
            dateSlider.maximumValue = count.floatValue - 1
        }
    }

    private func observeFourm() {
        $initialDateOfInvestmentIndex
            .sink { [weak self] (index) in
                // add weak self because im going to refernece the slider
                guard let index = index else { return }

                self?.dateSlider.value = index.floatValue

                if let dateString = self?.asset?.timeSeriesMontlyAdjusted.getMonthInfos()[index].date.MMYYFormat {
                    self?.initialDateOfInvestmentTextField.text = dateString
                }
            }.store(in: &subscribers)

        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestment)
            .compactMap({
                ($0.object as? UITextField)?.text
            }).sink { [weak self] (text) in
                print("Testing init \(text)")
                self?.initialInvestmentAmount = Int(text) ?? 0
            }.store(in: &subscribers)

        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: monthlyDollarCostAveragingAmount
        ).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] text in
            self?.monthlyDollarCostAveraging = Int(text) ?? 0
        }.store(in: &subscribers)

        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDollarCostAveraging, $initialDateOfInvestmentIndex)
            .sink { [weak self] (initialInvestmentAmount, monthlyDollarCostAveraging, initialDateOfInvestmentIndex) in

                print("Testing printing label \(initialInvestmentAmount), \(monthlyDollarCostAveraging), \(initialDateOfInvestmentIndex)")
                // Make sure all the fields are not nil before the calculation begins
                guard let initialInvestmentAmount = initialInvestmentAmount,
                      let monthlyDollarCostAveraging = monthlyDollarCostAveraging,
                      let initialDateOfInvestmentIndex = initialDateOfInvestmentIndex else {
                    return
                }

                let result = self?.dcaService.calculate(
                    initialInvestmentAmount: initialInvestmentAmount.doubleValue,
                    monthlyDollarcostAveragingAmount: monthlyDollarCostAveraging.doubleValue,
                    initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)

                print("Testing printing label")
                self?.currentValueLabel.text = result?.currentValue.toString
                self?.investmentAmountLabel.text = result?.investmentAmount.toString
                self?.gainLabel.text = result?.gain.toString
                self?.yeildLabel.text = result?.yeid.toString
                self?.annualReturnLabel.text = result?.annualReturn.toString
        }.store(in: &subscribers)
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

    // MARK: IBAction

    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
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
