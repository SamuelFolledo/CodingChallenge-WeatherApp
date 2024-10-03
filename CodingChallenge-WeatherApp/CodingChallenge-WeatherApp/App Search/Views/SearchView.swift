//
//  SearchView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @StateObject var vm: SearchViewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
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

                Button("Refresh") {
                    if let location = vm.locationManager.lastKnownLocation {
                        vm.fetchWeatherForCurrentLocation(location: location)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .navigationBarTitle("Weather", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                vm.showSearchView = true
                print("show search view")
            }) {
                Image(systemName: "magnifyingglass")
            })
            .sheet(isPresented: $vm.showSearchView) {
                WeatherView(vm: vm)
            }
        }
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
}

//#Preview {
//    SearchView(vm: )
//}
