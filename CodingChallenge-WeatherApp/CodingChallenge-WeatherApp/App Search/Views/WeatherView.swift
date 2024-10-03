//
//  WeatherView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/3/24.
//

import SwiftUI

struct WeatherView: View {
    var weatherData: WeatherData
    var weatherIcon: UIImage?
    var tapAction: (() -> Void)? = nil


    var body: some View {
        Button {
            tapAction?()
        } label: {
            VStack(spacing: vStackPadding) {
                //TODO: If given more time, come up with a custom Text view/modifiers
                Text(weatherData.cityName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primary)

                if let weatherIcon = weatherIcon {
                    ImageViewRepresentable(image: weatherIcon)
                        .frame(width: 100, height: 100)
                }

                Text("\(String(format: "%.1f", weatherData.temperature))\(measurementType.symbol)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)

                Text(weatherData.description)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
    }
}

