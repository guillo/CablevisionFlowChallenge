//
//  ViewController.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 05/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let apiService:APIService!
        apiService = APIService()
        var cities: [City]!
        cities = apiService.loadJson();
        
        let filteredArray = cities.filter( { (city: City) -> Bool in
            return city.name == "Cordoba"
        })
        
        print(filteredArray)
        
    }



}

