//
//  SearchRoute.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/2/24.
//

import UIKit

/// Enum to identify Search flow screen Types
enum SearchRoute: Hashable, Identifiable {
    case weatherDetail(weatherData: WeatherData, image: UIImage)

    var id: String {
        switch self {
        case .weatherDetail(let weatherData, _):
            "weatherDetail.\(weatherData.id)"
        }
    }

    static func == (lhs: SearchRoute, rhs: SearchRoute) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
