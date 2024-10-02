//
//  ContentView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeCoordinator = HomeCoordinator()
    @StateObject var searchCoordinator = SearchCoordinator()
    @StateObject var locationManager: LocationManager = LocationManager()

    var body: some View {
        if locationManager.hasRequestedAuthorization {
            searchView
        } else if locationManager.hasDeniedAuthorization {
            homeView
        } else {
            if locationManager.authorizationStatus == nil {
                ProgressView("Checking permissions...")
            } else {
                homeView
            }
        }
    }

    var homeView: some View {
        NavigationStack(path: $homeCoordinator.navigationPath) {
            homeCoordinator.build(locationManager: locationManager)
        }
    }

    var searchView: some View {
        NavigationStack(path: $searchCoordinator.navigationPath) {
            searchCoordinator.build(locationManager: locationManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
