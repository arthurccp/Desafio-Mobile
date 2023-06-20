//
//  ViewController.swift
//  Desafio Mobile
//
//  Created by Arthur on 17/06/2023.
//  Copyright © 2023 Arthur. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    var fetchingMore = false
    let parser = Parser()
    var results = [Resource]()
    var filteredResults = [Resource]()
    var isSearching = false
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
        setupNavigationItem()
        setupSearchBar()
    }
    
    func setuprefresh(){
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupTableView(){
        tableView.dataSource = self
        let nib = UINib(nibName: "ResourceTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ResourceTableViewCell")
    }
    
    @objc func openFilterViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) 
        guard let filterViewController = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else {
            return
        }
        navigationController?.pushViewController(filterViewController, animated: true)
    }

    func setupNavigationItem(){
        let filtersButton = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(openFilterViewController))
        let color = UIColor(red: 182.0/255.0, green: 211.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        filtersButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
        navigationItem.rightBarButtonItem = filtersButton
    }

    func loadData() {
        if let cachedData = UserDefaults.standard.data(forKey: "cachedData"),
            let cachedResults = try? JSONDecoder().decode([Resource].self, from: cachedData) {
            results = cachedResults
            tableView.reloadData() // Correção: Adicionar reloadData() aqui
            refreshControl.endRefreshing()
        } else {
            parser.parse { [weak self] data in
                self?.results = data
                if let serializedData = try? JSONEncoder().encode(data) {
                    UserDefaults.standard.set(serializedData, forKey: "cachedData")
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc func refreshData() {
        loadData()
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by value"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredResults.count : results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
        
        let resource = isSearching ? filteredResults[indexPath.row] : results[indexPath.row]
        cell.resource_id.text = resource.resourceID
        cell.update_at.text = "\(resource.updatedAt ?? 0)"
        cell.resource_value.text = resource.value
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            loadData()
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        print("beginBatchFetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.loadData()
            self?.tableView.reloadData()
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            isSearching = true
            filteredResults = results.filter { $0.value.localizedCaseInsensitiveContains(searchText) }
        } else {
            isSearching = false
            filteredResults.removeAll()
        }
        
        tableView.reloadData()
    }
}
