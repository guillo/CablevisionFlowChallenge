//
//  APIService.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 07/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:Any]

class APIService {
    
    func loadJson(completion :@escaping ([City]) -> ()) {
        if let url = Bundle.main.url(forResource: "citylist", withExtension: "json") {
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    
                    let json = try! JSONSerialization.jsonObject(with: data, options: [])
                    
                    let result = json
                    let dictionaries = result as! [JSONDictionary]
                    
                    let cities = dictionaries.compactMap(City.init)
                    
                    
                    DispatchQueue.main.async {
                        completion(cities)
                    }
                    
                } catch {
                    print("error:\(error)")
                }
            }
        }
    }
    
    func loadCityTempById(Id:Int32, completion :@escaping (NSNumber) -> ()) {
        
        let URLservices = "https://api.openweathermap.org/data/2.5/weather?id="+Id.description+"&units=metric&appid=6973f4507ea408da264ecbd4e8d0d43a"
        guard let sourcesURL = URL(string:URLservices) else {
            return
        }
        
        print(URLservices)
        
        URLSession.shared.dataTask(with: sourcesURL) { data, _, _ in
            
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                let result = json as! [String:Any]
                let main = result["main"] as! [String:Any]
                
                for (key, value) in main {
                    print("\(key) -> \(value)")
                    if key == "temp"{
                        DispatchQueue.main.async {
                            completion(value as! NSNumber)
                        }
                    }
                }
            }
        }.resume()
    }
}
