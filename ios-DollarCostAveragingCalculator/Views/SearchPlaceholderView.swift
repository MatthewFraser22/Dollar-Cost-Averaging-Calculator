//
//  SearchPlaceholderView.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-25.
//

import Foundation
import UIKit

class SearchPlaceholderView: UIView {
    private var imageView: UIImageView = {
       var iv = UIImageView()
        iv.image = UIImage(named: "imDca")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private var placeholderText: UILabel = {
       var label = UILabel()
        label.text = "Search for companies to calculate potential returns via cost averaging."
        label.font = UIFont(name: "AvenirNext-Medium", size: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        var verticalStackView = UIStackView(arrangedSubviews: [imageView,placeholderText])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 24
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
}
