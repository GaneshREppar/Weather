//
//  WeatherForcastViewData.swift
//  Weather
//
//  Created by Ganesh Eppar on 05/06/23.
//

import Foundation

class WeatherForcastViewData {
    let forcastDescription: String?
    let city: String
    let currentTemp: Double?
    let dayPredictions: [List]
    
    init(city: City, dayPredictions: [List]) {
        self.forcastDescription = dayPredictions.first?.weather.first?.description
        self.city = city.name
        self.currentTemp = dayPredictions.first?.main.temp
        self.dayPredictions = dayPredictions
    }
}
