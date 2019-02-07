//
//  APIService.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 07/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import Foundation

class APIService {
    
    func loadJson() -> [City]? {
        if let url = Bundle.main.url(forResource: "citylist", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Array<City>.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
}
