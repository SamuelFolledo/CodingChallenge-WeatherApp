//
//  WeatherService.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import CoreLocation
import Foundation
import Combine

//TODO: Check if needed
protocol WeatherServiceProtocol {
    func fetchWeather(for location: Location, completion: @escaping (Result<WeatherData, WeatherError>) -> Void)
}

class WeatherService: ObservableObject {
    private let apiKey = "YOUR_API_KEY_HERE"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let cache = UserDefaults.standard

    @Published var lastWeatherData: WeatherData?

    func fetchWeather(for location: Location) -> AnyPublisher<WeatherData, WeatherError> {
        let urlString = "\(baseURL)?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(apiKey)"
        return performRequest(with: urlString)
    }

    func fetchWeather(for cityName: String) -> AnyPublisher<WeatherData, WeatherError> {
        let urlString = "\(baseURL)?q=\(cityName)&units=metric&appid=\(apiKey)"
        return performRequest(with: urlString)
    }

    private func performRequest(with urlString: String) -> AnyPublisher<WeatherData, WeatherError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { response in
                let weatherData = WeatherData(cityName: response.name,
                                              temperature: response.temperature.value,
                                              description: response.weather.description,
                                              iconName: response.weather.icon)
                self.cacheWeatherData(weatherData)
                return weatherData
            }
            .mapError { error -> WeatherError in
                if let error = error as? DecodingError {
                    return .decodingError(error)
                } else {
                    return .networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }

    private func cacheWeatherData(_ weatherData: WeatherData) {
        if let encoded = try? JSONEncoder().encode(weatherData) {
            cache.set(encoded, forKey: "lastWeatherData")
        }
        self.lastWeatherData = weatherData
    }

    func loadCachedWeatherData() {
        if let savedWeatherData = cache.object(forKey: "lastWeatherData") as? Data,
           let decodedWeatherData = try? JSONDecoder().decode(WeatherData.self, from: savedWeatherData) {
            self.lastWeatherData = decodedWeatherData
        }
    }
}
