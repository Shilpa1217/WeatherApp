//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Shilpa Mulpuri on 12/20/20.
//

import Foundation
import UIKit

class WeatherDetailViewModel {
    private let apiKey = "64c87e180262e98c57a0377709f8dfa3"
    let zipcode: Int
    
    init(zipcode: Int) {
        self.zipcode = zipcode
    }
    
    func getCurrentWeather(completion: @escaping (CurrentWeather?, Error?) -> Void) {
        let weatherUrlString = "https://api.openweathermap.org/data/2.5/weather?zip=\(zipcode),us&appid=\(apiKey)&units=imperial"
        if let url = URL(string: weatherUrlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else { completion(nil, error); return }
                
                if let data = data {
                    do {
                        let weatherData = try JSONDecoder().decode(CurrentWeather.self, from: data)
                        completion(weatherData, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }.resume()
        }
    }
    
    func getIconImage(imageURL:URL, completion: @escaping (UIImage?, Error?) -> Void) {
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard error == nil,
                  let imageData = data else { completion(nil, error); return }
            completion(UIImage(data: imageData), nil)
        }.resume()
    }
}
