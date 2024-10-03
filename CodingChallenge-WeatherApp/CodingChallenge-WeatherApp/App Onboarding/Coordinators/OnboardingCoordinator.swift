//
//  OnboardingCoordinator.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import Combine

final class OnboardingCoordinator: ObservableObject {
    private var id: UUID = UUID()
    private var cancellables = Set<AnyCancellable>()

    @ViewBuilder func build(locationManager: LocationManager) -> some View {
        permissionView(locationManager: locationManager)
    }

    @ViewBuilder func permissionView(locationManager: LocationManager) -> some View {
        OnboardingView(vm: self.makeOnboardingViewModel(locationManager: locationManager))
    }

    //MARK: - Permission Methods
    func makeOnboardingViewModel(locationManager: LocationManager) -> OnboardingViewModel {
        let vm = OnboardingViewModel(locationManager: locationManager)
        return vm
    }
}
