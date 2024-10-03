//
//  Constants.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI

let weatherAPIKey = "361279ca20e9272b28c504a9b3023792"
let measurementType: MeasurementType = .imperial

let fakeWeatherData = WeatherData(cityName: "New York", temperature: 81, description: "Cloudy", iconName: "fakeIconName")
let sampleWeatherGetRequestUrl = "https://api.openweathermap.org/data/2.5/weather?q=London&units=metric&appid=361279ca20e9272b28c504a9b3023792"


let horizontalPadding: CGFloat = 16
let smallerHorizontalPadding: CGFloat = 8
let verticalPadding: CGFloat = 12
let smallerVerticalPadding: CGFloat = 6
let vStackPadding: CGFloat = 8
let roundedRectangleCornerRadius: CGFloat = 16
let appColor: Color = .blue
