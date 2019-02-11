////
////  City.swift
////  CablevisionFlowChallenge
////
////  Created by Mario Guillermo Boaglio on 07/02/2019.
////  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
////
//

import Foundation
import CoreLocation

class City {
    var id:Int32!
    var cityName:String!
    var country:String!
    var coord = [String:CLLocationDegrees]()
    
    init?(dictionary :JSONDictionary) {
        guard let cityName = dictionary["name"] as? String,
            let id = dictionary["id"] as? Int32,
            let country = dictionary["country"] as? String,
            let coord = dictionary["coord"] as? [String:CLLocationDegrees]
        else {
            return nil
        }
        self.id = id
        self.cityName = cityName
        self.country = country
        self.coord = coord

    }
    
    init(viewModel:CityViewModel) {
        self.id = viewModel.id
        self.cityName = viewModel.cityName
        self.country = viewModel.country
        self.coord = viewModel.coord
    }
}
