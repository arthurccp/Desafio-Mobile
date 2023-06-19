//
//  FilterViewController.swift
//  Desafio Mobile
//
//  Created by Arthur on 18/06/2023.
//  Copyright © 2023 Arthur. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate {
    
    private var selectedOption: String = "language_id"
    private var languageIDs: [String] = []
    private var moduleIDs: [String] = []
    private var filteredResults: [Resource] = []
    private var results: [Resource] = []
    private let parser = Parser()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scFilterId: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        scFilterId.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        loadData()
    }
    
    func setupTableView(){
        tableView.dataSource = self
        let nib = UINib(nibName: "FilterTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FilterTableViewCell")
    }
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        updateSelectedOption(selectedSegmentIndex)
    }
    
    func loadData() {
        parser.parse { [weak self] resources in
            self?.results = resources
            self?.filteredResults = resources
            self?.languageIDs = Array(Set(resources.map { $0.languageID })) // Filtrar os language_ids sem repetição
            self?.moduleIDs = Array(Set(resources.map { $0.moduleID })) // Filtrar os module_ids sem repetição
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func filterOptions() -> [String] {
        if selectedOption == "language_id" {
            return languageIDs
        } else if selectedOption == "module_id" {
            return moduleIDs
        } else {
            return []
        }
    }
    
    func updateSelectedOption(_ selectedSegmentIndex: Int) {
        if selectedSegmentIndex == 0 {
            selectedOption = "language_id"
        } else if selectedSegmentIndex == 1 {
            selectedOption = "module_id"
        }
        
        filteredResults = filterResults()
        tableView.reloadData()
    }
    
    func filterResults() -> [Resource] {
        if selectedOption == "language_id" {
            let selectedLanguageID = filterOptions()[scFilterId.selectedSegmentIndex]
            return results.filter { $0.languageID == selectedLanguageID }
        } else if selectedOption == "module_id" {
            let selectedModuleID = filterOptions()[scFilterId.selectedSegmentIndex]
            return results.filter { $0.moduleID == selectedModuleID }
        } else {
            return []
        }
    }

}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        
        let options = filterOptions()
        let option = options[indexPath.row]
        
        cell.nameFilter.text = option
        cell.swFilter.isOn = false
        
        return cell
    }
}
