//
//  SearchRoute.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/2/24.
//

import Foundation

/// Enum to identify Search flow screen Types
enum SearchRoute: String, Identifiable {
    case search
    case weatherDetail

    var id: String {
        self.rawValue
    }
}
