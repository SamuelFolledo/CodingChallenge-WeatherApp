//
//  WeatherError.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import Foundation

enum WeatherError: Error, Identifiable {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidImageData
    case unknown

    var id: String { localizedDescription }

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .invalidImageData:
            return "Invalid image data"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
