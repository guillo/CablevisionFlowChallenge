//
//  WeatherListViewModel.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 07/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import Foundation

class WeatherListViewModel:NSObject{
    @objc dynamic private(set) var weatherCityViewModels :[WeatherCityViewModel] = [WeatherCityViewModel]()
    private var token :NSKeyValueObservation?
    var bindToCityViewModels :(() -> ()) = {  }
    private var coreDataService :CoreDataService
    private var apiService :APIService
    
    init(coreDataService:CoreDataService, apiService :APIService) {
        self.coreDataService = coreDataService
        self.apiService = apiService
        super.init()
        
        token = self.observe(\.weatherCityViewModels) { _,_ in
            self.bindToCityViewModels()
        }
        
        populateWeatherCities()
    }
    
    func invalidateObservers() {
        self.token?.invalidate()
    }
    
    func populateWeatherCities() {
        self.coreDataService.getCities { [unowned self] cities in
            self.weatherCityViewModels = cities.compactMap(WeatherCityViewModel.init)
        }
    }
    
    func addCity(weatherCity: WeatherCityViewModel) {
        self.weatherCityViewModels.append(weatherCity)
    }
    
    func city(at index:Int) -> WeatherCityViewModel {
        return self.weatherCityViewModels[index]
    }
}

class WeatherCityViewModel : NSObject {
    var cityId:Int32!
    var cityName:String!
    var cityTemp:Int32!
    
    init(cityName:String!, cityTemp:Int32!, cityId:Int32!){
        self.cityName = cityName
        self.cityTemp = cityTemp
        self.cityId = cityId
    }
    
    init(city :CityWeather) {
        self.cityName = city.cityName
        self.cityTemp = city.cityTemp
        self.cityId = city.id
    }
    
}
