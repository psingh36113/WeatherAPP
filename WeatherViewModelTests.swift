//
//  WeatherViewModelTests.swift
//  MphasisWeatherAppTests
//
//  Created by PSingh on 8/21/24.
//

import Combine
import XCTest
@testable import MphasisWeatherApp // Replace with the actual module name
import SwiftUI

class MockWeatherService: WeatherServiceProtocol {
    var result: Result<Weather, Error>?
    
    func fetchWeatherData(for cityName: String) -> AnyPublisher<Weather, Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
}

class WeatherViewModelTests: XCTestCase {
    var sut: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        sut = WeatherViewModel(weatherService: mockWeatherService, cityName: "")
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockWeatherService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchWeatherData_success() {
        // Given
        let expectation = XCTestExpectation()
        let weather = Weather(
            weather: [],
            main: Weather.Main(
                temp: 30,
                temp_min: 20,
                temp_max: 40)
        )
        mockWeatherService.result = .success(weather)
        
        // When
        sut = WeatherViewModel(
            weatherService: mockWeatherService,
            cityName: "Boston"
        )
    
        sut
            .$city
            .sink { city in
                XCTAssertEqual(city, "Boston")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.25)
        
        // Then
        XCTAssertEqual(sut.temperation, "Temperature: 30.0°F")
        XCTAssertEqual(sut.minTemperation, "Minimum Temperature: 20.0°F")
        XCTAssertEqual(sut.maxTemperation, "Maximum Temperature: 40.0°F")
        XCTAssertNil(sut.errorMessage)
    }
    
    func testFetchWeatherData_emptyCityName() {
        // Given
        let expectation = XCTestExpectation()
        
        // When
        sut
            .$city
            .sink { city in
                XCTAssertEqual(city, "")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.25)
        
        // Then
        XCTAssertEqual(sut.errorMessage, "Please enter city name")
    }
    
    func testFetchWeatherData_failure() {
        // Given
        let expectation = XCTestExpectation()
        
        // When
        sut = WeatherViewModel(
            weatherService: mockWeatherService,
            cityName: "Boston"
        )
        
        sut
            .$city
            .sink { city in
                XCTAssertEqual(city, "Boston")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.25)
        
        // Then
        XCTAssertEqual(sut.errorMessage, "Sorry, Unable to fetch the weather. Please try again")
    }
}
