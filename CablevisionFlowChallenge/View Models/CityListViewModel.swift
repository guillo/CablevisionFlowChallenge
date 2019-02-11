//
//  CityListViewModel.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 09/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import Foundation
import CoreLocation

class CityListViewModel:NSObject{
    
    @objc dynamic private(set) var cityViewModels :[CityViewModel] = [CityViewModel]()
    @objc dynamic private(set) var filterCityViewModels :[CityViewModel] = [CityViewModel]()
    private var token :NSKeyValueObservation?
    private var filterToken :NSKeyValueObservation?
    var bindToCityViewModels :(() -> ()) = {  }
    var bindToFilterCityViewModels :(() -> ()) = {  }
    private var apiService :APIService
    
    init(apiService :APIService) {
        
        self.apiService = apiService
        super.init()
        
        token = self.observe(\.cityViewModels) { _,_ in
            self.bindToCityViewModels()
        }
        
        filterToken = self.observe(\.filterCityViewModels) { _,_ in
            self.bindToFilterCityViewModels()
        }
        populateCities()
    }
    
    func invalidateObservers() {
        self.token?.invalidate()
    }
    
    func populateCities() {
        self.apiService.loadJson { [unowned self] cities in
            self.cityViewModels = cities.compactMap(CityViewModel.init)
        }
    }
    
    func filterCities(searchText: String) {
       
        filterCityViewModels = cityViewModels.filter({( city : CityViewModel) -> Bool in
            return city.cityName.lowercased().contains(searchText.lowercased())
        })
    }
    
    func addCity(city: CityViewModel) {
        self.cityViewModels.append(city)
    }
    
    func city(at index:Int) -> CityViewModel {
        return self.cityViewModels[index]
    }
    func cityFilter(at index:Int) -> CityViewModel {
        return self.filterCityViewModels[index]
    }
}

class CityViewModel : NSObject {
    
    var id:Int32!
    var cityName:String!
    var country:String!
    var coord = [String:CLLocationDegrees]()
    
    
    init(id:Int32!, cityName:String!, country:String!, coord:[String:CLLocationDegrees]!){
        self.id = id
        self.cityName = cityName
        self.country = country
        self.coord = coord
    }
    
    init(city :City) {
        self.id = city.id
        self.cityName = city.cityName
        self.country = city.country
        self.coord = city.coord
    }
    
}
