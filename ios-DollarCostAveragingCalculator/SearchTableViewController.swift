//
//  SearchTableViewController.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-20.
//

import UIKit

class SearchTableViewController: UITableViewController {

    // MARK: Properties

    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter a company name or symbol"
        searchController.searchBar.autocapitalizationType = .allCharacters
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }

}

// MARK: Extensions

extension SearchTableViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
