//
//  SearchTableViewController.swift
//  ios-DollarCostAveragingCalculator
//
//  Created by Matthew Fraser on 2022-07-20.
//

import UIKit
import Combine
import SwiftUI
import MBProgressHUD

class SearchTableViewController: UITableViewController, ViewLoadingAnimation {

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

    // Observable property for search query text
    @Published private var searchQuery = String()
    private var searchResults: SearchResults?
    @Published private var mode: Mode = .onBoarding
    private let apiService = APIService.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupTableView()
        startObservers()
        setupTableView()
    }

    // Removes the tableview lines
    private func setupTableView() {
        tableView.tableFooterView = UIView()
    }

    private func startObservers() {
        // Weak and unowned references enable one instance in a reference cycle to refer to the other instance without keeping a strong hold on it
        // debounce waits for a certain period of time before it responds
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
                self.apiService.fetchSymbolsPublisher(keyWords: searchQuery)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            MBProgressHUD.hide(for: self.view, animated: true)
                        case let .failure(error):
                            print("Error: \(error)")
                        }
                    } receiveValue: { results in
                        print("Testing here ")
                        self.searchResults = results
                        self.tableView.reloadData()
                    }.store(in: &self.cancellables)
            }.store(in: &cancellables)

        $mode
            .sink { [unowned self] mode in
                switch mode {
                case .onBoarding:
                    self.tableView.backgroundView = SearchPlaceholderView()
                case .search:
                    self.tableView.backgroundView = nil
                }
            }.store(in: &cancellables)
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // Table View

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell

        if let searchResults = searchResults {
            let searchResult = searchResults.results[indexPath.row]
            cell.configure(with: searchResult)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCalculator", sender: nil)
    }

    private enum Mode {
        case onBoarding
        case search
    }
}

// MARK: Extensions

extension SearchTableViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        mode = searchController.isActive ? .search : .onBoarding
        hideLoadingAnimation()

        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }

        showLoadingAnimation()
        self.searchQuery = searchQuery
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
}
