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
    }

    @UserDefault(key: Keys.didShowOnboarding, defaultValue: false)
    static var didShowOnboarding: Bool
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
