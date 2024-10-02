//
//  LocationManager.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    //TODO: Implement to use a stored location instead
    @Published var lastKnownLocation: Location?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var hasRequestedAuthorization: Bool = false
    @Published var hasDeniedAuthorization: Bool = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
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
            print("Location status is now \(statusText()), go to search view")
            hasRequestedAuthorization = true
        case .notDetermined:
            print("TODO: Ask for user permission")
        case .denied, .restricted:
            print("TODO: Show an alert or view that redirects to Settings")
            hasDeniedAuthorization = true
        default:
            break
        }
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
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
