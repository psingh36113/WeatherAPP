//
//  WeatherViewModel.swift
//  MphasisWeatherApp
//
//  Created by PSingh on 8/21/24.
//

import Foundation
import Combine

enum WeatherState: Equatable {
    case loaded
    case error(error: String)
}

class WeatherViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var errorMessage: String?
    @Published var city: String
    
    var weatherState: WeatherState = .loaded
    private var weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        cityName: String = ""
    ) {
        self.weatherService = weatherService
        self.city = cityName
        getWeather(cityName: cityName)
    }
    
    func getWeather(cityName: String) {
        weatherService.fetchWeatherData(for: cityName)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    if cityName.isEmpty {
                        self?.errorMessage = "Please enter city name"
                    } else {
                        self?.errorMessage = "Sorry, Unable to fetch the weather. Please try again"
                    }
                    self?.weatherState = .error(
                        error: self?.errorMessage ?? error.localizedDescription
                    )
                }
            }, receiveValue: { [weak self] weather in
                self?.weather = weather
                self?.weatherState = .loaded
                
            })
            .store(in: &cancellables)
    }
}

extension WeatherViewModel {
    var temperation: String {
        "Temperature: \(weather?.main.temp ?? 0)°F"
    }
    
    var minTemperation: String {
        "Minimum Temperature: \(weather?.main.temp_min ?? 0)°F"
    }
    
    var maxTemperation: String {
        "Maximum Temperature: \(weather?.main.temp_max ?? 0)°F"
    }
}
