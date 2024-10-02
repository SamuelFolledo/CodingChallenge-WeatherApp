//
//  SearchDetailView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import Combine
import SwiftUI

struct SearchDetailView: View {
    let weatherData: WeatherData

    var body: some View {
        Text("Weather on \(weatherData.cityName) is \(weatherData.temperature)")
    }
}
