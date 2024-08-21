//
//  WeatherModel.swift
//  MphasisWeatherApp
//
//  Created by PSingh on 8/21/24.
//

import Foundation

struct Weather: Codable {
    struct WeatherInfo: Codable {
        let description: String
        let icon: String
    }
    let weather: [WeatherInfo]
    let main: Main

    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
}
