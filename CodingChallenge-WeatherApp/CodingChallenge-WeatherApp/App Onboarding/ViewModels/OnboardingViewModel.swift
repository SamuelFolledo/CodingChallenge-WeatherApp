//
//  OnboardingViewModel.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import CoreLocation
import Combine

class OnboardingViewModel: BaseViewModel {
    @Published var locationManager: LocationManager
//    let locationPermissionGranted = PassthroughSubject<Bool, Never>()

    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
    }
}
