//
//  SearchView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    @ObservedObject var vm: SearchViewModel
    

    var body: some View {
        GeometryReader { reader in
            ScrollView(showsIndicators: false) {
                VStack(spacing: vStackPadding) {
                    weatherView

                    Text("Location Permission: \(vm.locationManager.statusText())")
                }
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .safeAreaInset(edge: .bottom) {
            searchView
        }
        .onAppear {
            if let location = vm.locationManager.lastKnownLocation {
                vm.fetchWeatherForCurrentLocation(location: location)
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.isAlertPresented, actions: {
            VStack {
                if !vm.alertMessage.isEmpty {
                    Text(vm.alertMessage)
                }

                Button("OK") {
                    vm.isAlertPresented = false
                }
            }
        })
        .overlay {
            LoadingView(message: vm.loadingMessage)
        }
    }

    var searchView: some View {
        VStack(spacing: vStackPadding * 2) {
            TextField("Enter a city name", text: $vm.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    vm.searchWeather(for: vm.searchText)
//                    if let location = vm.locationManager.lastKnownLocation {
//                        vm.fetchWeatherForCurrentLocation(location: location)
//                    }
                }
                .submitLabel(.search)
                .disableAutocorrection(verticalSizeClass == .compact ? true : false) //reduce keyboard height on small height (landscape on iPhone)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
    }

//    var searchButton: some View {
//        Button {
//            vm.searchWeather(for: vm.searchText)
//        } label: {
//            Text("Search")
//                .padding(.horizontal, horizontalPadding)
//                .padding(.vertical, verticalPadding)
//                .frame(maxWidth: .infinity)
//                .background(appColor)
//                .foregroundColor(.white)
//                .cornerRadius(roundedRectangleCornerRadius)
//        }
//    }

    @ViewBuilder var weatherView: some View {
        if let weatherData = vm.weatherData {
            Text(weatherData.cityName)
                .font(.largeTitle)
                .fontWeight(.bold)

            if let weatherIcon = vm.weatherIcon {
                Image(uiImage: weatherIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }

            Text("\(String(format: "%.1f", weatherData.temperature))\(measurementType.symbol)")
                .font(.title)
                .fontWeight(.semibold)

            Text(weatherData.description)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
}

//#Preview {
//    SearchView(vm: )
//}
