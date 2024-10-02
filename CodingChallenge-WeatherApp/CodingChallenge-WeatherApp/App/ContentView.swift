//
//  ContentView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var permissionCoordinator = PermissionCoordinator()
    @StateObject var searchCoordinator = SearchCoordinator()
    @StateObject var locationManager: LocationManager = LocationManager()

    var body: some View {
        if locationManager.hasRequestedAuthorization {
            searchView
        } else if locationManager.hasDeniedAuthorization {
            permissionView
        } else {
            if locationManager.authorizationStatus == nil {
                ProgressView("Checking permissions...")
            } else {
                permissionView
            }
        }
    }

    var permissionView: some View {
        NavigationStack(path: $permissionCoordinator.navigationPath) {
            permissionCoordinator.build(locationManager: locationManager)
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
