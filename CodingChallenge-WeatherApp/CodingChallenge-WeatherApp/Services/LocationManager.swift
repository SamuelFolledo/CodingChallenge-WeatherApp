//
//  LocationManager.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
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

    ///depending on the state: if location permission is granted, then perform search to current location. Else, request location permission if possible
    func searchLocationButtonAction() {
        switch state {
        case .notDetermined:
            requestLocationPermission()
        case .authorized:
            refreshLastKnownLocation()
        case .skipped:
            //TODO: check status
            if let authorizationStatus {
                switch authorizationStatus {
                case .notDetermined:
                    requestLocationPermission()
                case .restricted, .denied:
                    print("TODO: Show an alert with a button to go to Settings")
                case .authorizedAlways, .authorizedWhenInUse:
                    //if it was skipped but now it was authorized, then get last location
                    refreshLastKnownLocation()
                @unknown default:
                    break
                }
            } else {
                requestLocationPermission()
            }
        }
    }

    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func refreshLastKnownLocation() {
        locationManager.requestLocation()
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

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let newLastKnownLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print("Updated Last known location from (\(lastKnownLocation?.latitude ?? -1),\(lastKnownLocation?.longitude ?? -1)) into (\(newLastKnownLocation.latitude),\(newLastKnownLocation.longitude))")
        lastKnownLocation = newLastKnownLocation
    }

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

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error on location manager: \(error.localizedDescription)")
    }
}
