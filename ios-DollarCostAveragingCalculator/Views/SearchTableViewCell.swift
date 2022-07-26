//
//  SearchTableViewCell.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-25.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet private weak var assetNameLabel: UILabel!
    @IBOutlet private weak var assetSymbolLabel: UILabel!
    @IBOutlet private weak var assetTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with searchResult: SearchResult) {
        assetNameLabel.text = searchResult.name
        assetSymbolLabel.text = searchResult.symbol
        assetTypeLabel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
    }

}
