//
//  LocationState.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/3/24.
//

import SwiftUI

enum LocationState: String, Codable {
    ///when location permission has not been presented yet
    case notDetermined
    case authorized
    case skipped

    var iconName: String {
        switch self {
        case .authorized:
            return "location.fill"
        case .skipped:
            return "location.slash.fill"
        case .notDetermined:
            return "location"
        @unknown default:
            return "questionmark"
        }
    }

    var iconColor: Color {
        switch self {
        case .authorized:
            return .green
        case .skipped:
            return .red
        case .notDetermined:
            return .yellow
        @unknown default:
            return .gray
        }
    }
}
