//
//  WeatherListViewController.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 07/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import UIKit
import CoreData

class WeatherListViewController: UITableViewController {
    private var apiService:APIService!
    private var coreDataService:CoreDataService!
    private var weatherListViewModel:WeatherListViewModel!
    private var dataSource:TableViewDataSource<WeatherTableViewCell, WeatherCityViewModel>!
    
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataService = CoreDataService()
        apiService = APIService()
        
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func updateUI() {
        self.weatherListViewModel = WeatherListViewModel(coreDataService: coreDataService, apiService: apiService)
        
        self.weatherListViewModel.bindToCityViewModels = {
            self.updateDataSource()
        }
    }
    
    private func updateDataSource() {
        self.dataSource = TableViewDataSource(cellIdentifier: Cells.weather, items: self.weatherListViewModel.weatherCityViewModels) { cell, vm in
            cell.cityNameLabel.text = vm.cityName
            
            self.apiService.loadCityTempById(Id: vm.cityId, completion: { [unowned self] temp in
                cell.cityTempLabel.text = temp.description
            })
        }
        
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
