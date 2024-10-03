//
//  SearchView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @ObservedObject var vm: SearchViewModel

    var body: some View {
        GeometryReader { reader in
            VStack(spacing: vStackPadding) {
                if vm.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let weatherData = vm.weatherData {
                    Text(weatherData.cityName)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    if let weatherIcon = vm.weatherIcon {
                        Image(uiImage: weatherIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }

                    Text("\(String(format: "%.1f", weatherData.temperature))°C")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text(weatherData.description)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                Text("Location Permission: \(vm.locationManager.statusText())")
            }
            .padding(.horizontal, horizontalPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .safeAreaInset(edge: .bottom) {
            searchView
        }
        .navigationBarTitle("Search Weather", displayMode: .inline)
        .onAppear {
            if let location = vm.locationManager.lastKnownLocation {
                vm.fetchWeatherForCurrentLocation(location: location)
            }
        }
        .alert(item: $vm.error) { error in
            Alert(title: Text("Error"),
                  message: Text(error.localizedDescription),
                  dismissButton: .default(Text("OK")))
        }
    }

    var refreshButton: some View {
        Button("Refresh") {
            if let location = vm.locationManager.lastKnownLocation {
                vm.fetchWeatherForCurrentLocation(location: location)
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(roundedRectangleCornerRadius)
    }

    var searchView: some View {
        VStack(spacing: vStackPadding * 2) {
            TextField("Search", text: $vm.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            searchButton
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
    }

    var searchButton: some View {
        Button {
            if let location = vm.locationManager.lastKnownLocation {
                vm.fetchWeatherForCurrentLocation(location: location)
            }
        } label: {
            Text("Search")
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(roundedRectangleCornerRadius)
        }
    }
}

//#Preview {
//    SearchView(vm: )
//}
