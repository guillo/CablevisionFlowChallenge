//
//  AddCityViewController.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 09/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import UIKit
import CoreData

class AddCityViewController: UITableViewController {
    
    private var apiService:APIService!
    private var coreDataService:CoreDataService!
    private var cityListViewModel:CityListViewModel!
    private var dataSource:TableViewDataSource<CityTableViewCell, CityViewModel>!
    private var filterDataSource:TableViewDataSource<CityTableViewCell, CityViewModel>!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search City"
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            
            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }
        apiService = APIService()
        coreDataService = CoreDataService()
        updateUI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func updateUI() {
        
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        self.cityListViewModel = CityListViewModel(apiService :self.apiService)
        
        self.cityListViewModel.bindToCityViewModels = {
            self.updateDataSource()
            indicator.stopAnimating()
        }
    }
    
    private func updateDataSource() {
        self.dataSource = TableViewDataSource(cellIdentifier: Cells.city, items: self.cityListViewModel.cityViewModels) { cell, vm in
            cell.nameLabel.text = vm.cityName
            cell.countryLabel.text = vm.country
            let coord = vm.coord.values
            cell.latlonLabel.text = "Lat - Lon" + coord.description
        }
        
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    private func updateFilterDataSource() {
        self.dataSource = TableViewDataSource(cellIdentifier: Cells.city, items: self.cityListViewModel.filterCityViewModels) { cell, vm in
            cell.nameLabel.text = vm.cityName
            cell.countryLabel.text = vm.country
            let coord = vm.coord.values
            cell.latlonLabel.text = "Lat - Lon" + coord.description
        }
        
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("indexPath not found")
        }
        
        var city:CityViewModel
        if(isFiltering()){
            city = cityListViewModel.cityFilter(at: indexPath.row)
        }
        else{
            city = cityListViewModel.city(at: indexPath.row)
        }
        
        coreDataService.saveCity(city: city)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        cityListViewModel.filterCities(searchText: searchText)
        
        self.cityListViewModel.bindToFilterCityViewModels = {
            self.updateFilterDataSource()
        }
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
        print(cell.nameLabel)
    }
}

extension AddCityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if(isFiltering()){
            let filterText = searchController.searchBar.text!
            if filterText.count >= 3 {
                filterContentForSearchText(filterText)
            }
        }
        else{
            updateDataSource()
        }
    }
}
