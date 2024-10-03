//
//  SearchDetailView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI

struct SearchDetailView: View {
    let weatherData: WeatherData
    let image: UIImage

    var body: some View {
        WeatherView(weatherData: weatherData, weatherIcon: image)
    }
}
