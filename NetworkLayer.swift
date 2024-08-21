//
//  NetworkLayer.swift
//  MphasisWeatherApp
//
//  Created by PSingh on 8/21/24.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func fetchWeatherData(for cityName: String) -> AnyPublisher<Weather, Error>
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "46c387da00c056042ef733ce3eb4d49c"
    
    func fetchWeatherData(for cityName: String) -> AnyPublisher<Weather, Error> {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 
                        httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Weather.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
