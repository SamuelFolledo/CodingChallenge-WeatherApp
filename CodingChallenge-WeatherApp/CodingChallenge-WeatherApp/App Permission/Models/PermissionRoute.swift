//
//  PermissionRoute.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/2/24.
//

import Foundation

enum PermissionRoute: Hashable, Identifiable {
    ///Fresh install flow to ask user for location permission
    //    case initialLocationPermission
    ///Flow when app has location permission. Keyword is current location after location permission is granted
    /// - parameter keyword: current location
    //    case hasPreviousSearch(keyword: String)
    case locationPermissionNotGranted

    //    var id: Self { return self }

    var id: String {
        switch self {
            //        case .initialLocationPermission:
            //            return "initialLocationPermission"
            //        case .hasPreviousSearch(let keyword):
            //            return "hasPreviousSearch(\(keyword))"
        case .locationPermissionNotGranted:
            return "locationPermissionNotGranted"
        }
    }

    static func == (lhs: PermissionRoute, rhs: PermissionRoute) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
