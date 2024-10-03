//
//  WeatherData.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI

//struct WeatherDataTests {
//    //TODO: Add tests
////    @Test
////    func example() throws {
////        #expect(WeatherData().text == "Hello, World!")
////    }
//
//    var cityName: String
//    var temperature: Double
//    var description: String
//    var iconName: String
//}

//struct WeatherResponse: Codable {
//    let name: String
//    let temperature: Temperature
//    let weather: Weather
//}

struct WeatherData: Codable, Identifiable {
    var id = UUID()
    let cityName: String
    let temperature: Double
    let description: String
    let iconName: String?
}

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let base: String
    let id: Int
    let main: Main
    let coord: Coord
    let wind: Wind
    let sys: Sys
    let weather: [Weather]
    let visibility: Int
    let clouds: Clouds
    let timezone: Int
    let name: String
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
