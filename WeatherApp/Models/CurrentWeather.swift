//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Shilpa Mulpuri on 12/20/20.
//

import Foundation

struct CurrentWeather: Decodable {
    private let weather: [WeatherInfo]
    var mainWeatherInfo: WeatherInfo? {
        return weather.first
    }
    
    let main: WeatherMain
    let visibility: Int
    let sun: Sun
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case visibility
        case sun = "sys"
        case name
    }
}

struct WeatherInfo: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}

struct WeatherMain: Decodable {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case humidity
    }
}

struct Sun: Decodable {
    let set: Double
    let rise: Double
    
    enum CodingKeys: String, CodingKey {
        case set = "sunset"
        case rise = "sunrise"
    }
}
