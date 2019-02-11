//
//  CoreDataService.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 10/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataService{
    
    func saveCity(city:CityViewModel){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CityWeather", in: context)
        let newCity = NSManagedObject(entity: entity!, insertInto: context)
        newCity.setValue(city.id, forKey: "id")
        newCity.setValue(city.cityName, forKey: "cityName")
        newCity.setValue(city.country, forKey: "country")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getCities(completion :@escaping ([CityWeather]) -> ()) {
       
        var weatherCities:[CityWeather] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        DispatchQueue.global(qos: .background).async {
            // do your job here
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityWeather")
                request.returnsObjectsAsFaults = false
              
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "cityName") as! String)
                }
                weatherCities = result as! [CityWeather]
                DispatchQueue.main.async {
                    // update ui here
                    completion(weatherCities)
                }
            } catch {
                print("error:\(error)")
            }
        }
    }
}
