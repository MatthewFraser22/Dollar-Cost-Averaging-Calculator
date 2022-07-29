//
//  DateSelectionTableViewController.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-28.
//

import Foundation
import UIKit

class DateSelectionTableViewController: UITableViewController {
    var timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted?
    private var monthInfos: [MonthInfo] = []
    var selectedIndex: Int?
    var didSelectDate: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMonthInfos()
        setupNavigation()
    }

    private func setupNavigation() {
        title = "Select Date"
    }

    private func setupMonthInfos() {
        monthInfos = timeSeriesMonthlyAdjusted?.getMonthInfos() ?? []
    }
}

extension DateSelectionTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthInfos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let monthInfo = monthInfos[indexPath.item]

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DateSelectionTableViewCell

        let isSelected = indexPath.item == selectedIndex
        cell.configure(with: monthInfo, index: indexPath.item, isSelected: isSelected)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectDate?(indexPath.item)
    }
}

class DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!

    func configure(with monthInfo: MonthInfo, index: Int, isSelected: Bool) {
        monthLabel.text = monthInfo.date.MMYYFormat
        accessoryType = isSelected ? .checkmark : .none
        if index == 1 {
            monthsAgoLabel.text = "1 month ago"
        } else if index > 1 {
            monthsAgoLabel.text = "\(index) months ago"
        } else {
            // index = 0
            monthsAgoLabel.text = "Just invested"
        }
    }
}
