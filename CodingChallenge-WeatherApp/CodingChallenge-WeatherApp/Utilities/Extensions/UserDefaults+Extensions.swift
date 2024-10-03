//
//  UserDefaults+Extensions.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/2/24.
//

import Foundation

extension UserDefaults {
    public enum Keys {
        static let didShowOnboarding = "didShowOnboarding"
        static let lastWeatherData = "lastWeatherData"
        static let lastIconName = "lastIconName"
    }

    @UserDefault(key: Keys.didShowOnboarding, defaultValue: false)
    static var didShowOnboarding: Bool

    @UserDefault(key: Keys.lastWeatherData, defaultValue: nil)
    static var lastWeatherData: Data?

    @UserDefault(key: Keys.lastIconName, defaultValue: nil)
    static var lastIconName: String?
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
