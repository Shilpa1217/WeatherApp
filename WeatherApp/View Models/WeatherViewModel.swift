//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Shilpa Mulpuri on 12/20/20.
//

import Foundation

class WeatherViewModel {
    private let zipcodeKey = "zipcodes"
    private let prepopulatedZipcodes = [30005, 75039,54965]
    var zipcodes: [Int] {
        guard let zipcodeArray = UserDefaults.standard.array(forKey: "zipcodes") as? [Int] else {
            return prepopulatedZipcodes
        }
        
        return zipcodeArray
    }
    
    var selectedZipcode: Int!
    
    func save(zipcode: Int) {
        var allZipcodes = UserDefaults.standard.array(forKey: "zipcodes") as? [Int] ?? prepopulatedZipcodes
        allZipcodes.append(zipcode)
        UserDefaults.standard.setValue(allZipcodes, forKey: zipcodeKey)
        UserDefaults.standard.synchronize()
    }
    func remove(at: Int){
        var allZipcodes = UserDefaults.standard.array(forKey: "zipcodes")  as? [Int] ?? prepopulatedZipcodes
        allZipcodes.remove(at: at)
        UserDefaults.standard.setValue(allZipcodes, forKey: zipcodeKey)
        UserDefaults.standard.synchronize()
    }
}
