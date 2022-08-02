//
//  ViewLoadingAnimation.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-26.
//

import Foundation
import UIKit
import MBProgressHUD

// make sure this protocol is only implemented into a view controller and not something else
// where Self: UIViewController
protocol ViewLoadingAnimation where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

extension ViewLoadingAnimation {
    func showLoadingAnimation() {

        guard view.subviews.filter({ $0 is MBProgressHUD}).isEmpty == false else { return }

        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }

    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
