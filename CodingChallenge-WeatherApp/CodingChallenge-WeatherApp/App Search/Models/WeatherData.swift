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

struct WeatherResponse: Codable {
    let name: String
    let temperature: Temperature
    let weather: Weather
}

struct Temperature: Codable {
    var value: Double
    var unit: String
}

struct Weather: Codable {
    let description: String
    let icon: String
}
