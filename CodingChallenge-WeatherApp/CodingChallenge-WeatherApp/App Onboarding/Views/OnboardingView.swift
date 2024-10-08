//
//  OnboardingView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import Combine
import SwiftUI

struct OnboardingView: View {
    @ObservedObject var vm: OnboardingViewModel

    var body: some View {
        VStack {
            Text("Location Permission")
                .font(.title)
                .padding()

            Text("In order to search the weather for your current location, you need to allow the app to access your location.")
                .font(.subheadline)
                .padding()

            Spacer()

            Button("Request Location Permission") {
                vm.locationManager.requestLocationPermission()
            }
            .foregroundStyle(Color.white)
            .padding()
            .background { Color.accentColor }
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Button("Skip for now") {
                vm.locationManager.updateState(.skipped)
            }
            .padding()
        }
        .padding()
    }
}
