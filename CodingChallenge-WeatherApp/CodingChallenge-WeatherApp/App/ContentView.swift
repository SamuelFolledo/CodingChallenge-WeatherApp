//
//  ContentView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var permissionCoordinator = OnboardingCoordinator()
    @StateObject var searchCoordinator = SearchCoordinator()
    @StateObject var locationManager: LocationManager = LocationManager()

    var body: some View {
        switch locationManager.state {
        case .notDetermined:
            permissionView
        case .authorized, .skipped:
            searchView
        }
    }

    var permissionView: some View {
        permissionCoordinator.build(locationManager: locationManager)
    }

    var searchView: some View {
        NavigationStack(path: $searchCoordinator.navigationPath) {
            searchCoordinator.build(locationManager: locationManager)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
