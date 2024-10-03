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
    private let apiKey = weatherAPIKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    @Published var lastWeatherData: WeatherData?

    func fetchWeather(for location: Location) -> AnyPublisher<WeatherData, WeatherError> {
        let urlString = "\(baseURL)?lat=\(location.latitude)&lon=\(location.longitude)&units=\(measurementType.rawValue)&appid=\(apiKey)"
        return performRequest(with: urlString)
    }

    func fetchWeather(for cityName: String) -> AnyPublisher<WeatherData, WeatherError> {
        let urlString = "\(baseURL)?q=\(cityName)&units=\(measurementType.rawValue)&appid=\(apiKey)"
        return performRequest(with: urlString)
    }

    private func performRequest(with urlString: String) -> AnyPublisher<WeatherData, WeatherError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                //Uncomment to view the response
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                   let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                    print("GET result from url: \(urlString) is JSON:")
                    print(prettyPrintedString)
                }
            })
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { response in
                let weatherData = WeatherData(cityName: response.name,
                                              temperature: response.main.temp,
                                              description: response.weather.first?.main ?? "no description",
                                              iconName: response.weather.first?.icon ?? "placeholderIcon")
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
            UserDefaults.lastWeatherData = encoded
        }
        self.lastWeatherData = weatherData
    }

    func loadCachedWeatherData() {
        if let lastWeatherData = UserDefaults.lastWeatherData {
            self.lastWeatherData = try? JSONDecoder().decode(WeatherData.self, from: lastWeatherData)
        }
    }
}
