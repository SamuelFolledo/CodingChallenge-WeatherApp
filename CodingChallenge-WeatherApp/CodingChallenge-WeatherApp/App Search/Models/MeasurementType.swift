//
//  MeasurementType.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/2/24.
//

import Foundation

enum MeasurementType: String {
    case metric
    case imperial

    var symbol: String {
        switch self {
        case .metric:
            return "°C"
        case .imperial:
            return "°F"
        }
    }
}
