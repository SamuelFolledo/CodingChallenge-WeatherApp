//
//  AppStrings.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import Foundation

enum AppString {
    //TODO: Use NSLocalizedString by running the following in Terminal
    //genstrings -o en.lproj *.swift // that means “read all Swift files for localized strings, then write them out to the localized strings file for the English project.”
    //let buttonTitle = NSLocalizedString("bear", comment: "The name of the animal")

    //TODO: Add accessibility to any views like so
    //.accessibilityLabel(Text(AppString.searchplaceholderAccessibilityLabel))

    static let noInternetConnection = "No internet connection"
    static let noDataAvailable = "No data available"
    static let errorOccurred = "Error occurred"
    static let invalidResponse = "Invalid response"
    static let loading = "Loading..."
    static let noLocationAccess = "No location access"
    static let locationAccessDenied = "Location access denied"
    static let locationAccessNotDetermined = "Location access not determined"
    static let locationAccessRestricted = "Location access restricted"
    static let locationServicesDisabled = "Location services disabled"
    static let locationServicesNotAvailable = "Location services not available"
    static let locationServicesUnavailable = "Location services unavailable"
    static let locationServicesUnknown = "Location services unknown"
    static let locationServicesNotEnabled = "Location services not enabled"
    static let locationServicesNotDeterminedError = "Location services not determined error"
    static let locationServicesRestrictedError = "Location services restricted error"

    static let searchPlaceholder = "Enter a city, country, or zip code"
    static let searchplaceholderAccessibilityLabel = "A field to enter a city, country, or zip code to perform a search."
    static let searchButtonTitle = "Search"
    static let searchButtonAccessibilityLabel = "Search for weather information"
}
