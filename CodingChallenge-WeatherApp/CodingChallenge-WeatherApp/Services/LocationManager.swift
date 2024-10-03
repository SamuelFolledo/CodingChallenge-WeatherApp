//
//  LocationManager.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import CoreLocation
import Combine

enum LocationState: String, Codable {
    ///when location permission has not been presented yet
    case notDetermined
    case authorized
    case skipped
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    //TODO: Implement to use a stored location instead
    @Published var lastKnownLocation: Location?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published private(set) var state: LocationState = .notDetermined

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    //TODO: Implement to use a stored location instead
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        lastKnownLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            updateState(.authorized)
        case .notDetermined:
            if UserDefaults.didShowOnboarding {
                updateState(.skipped)
            } else {
                updateState(.notDetermined)
            }
        case .denied, .restricted:
            updateState(.skipped)
        default:
            break
        }
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

    func updateState(_ toState: LocationState) {
        guard state != toState else { return }
        print("Updating state from \(state.rawValue) to \(toState.rawValue). didShowOnboarding \(UserDefaults.didShowOnboarding)")
        switch toState {
        case .notDetermined:
            break
        case .authorized, .skipped:
            UserDefaults.didShowOnboarding = true
        }
        state = toState
    }

    func statusText() -> String {
        guard let status = authorizationStatus else {
            return "Unknown"
        }
        switch status {
        case .notDetermined:
            return "Not determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorizedAlways:
            return "Authorized always"
        case .authorizedWhenInUse:
            return "Authorized when in use"
        @unknown default:
            return "Unknown"
        }
    }
}
