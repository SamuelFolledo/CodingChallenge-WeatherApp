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
                }
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .safeAreaInset(edge: .bottom) {
            searchView
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                //Bonus Feature: locate me/location permssion button
                Button {
                    vm.locationManager.searchLocationButtonAction()
                } label: {
                    Image(systemName: vm.locationManager.state.iconName)
                        .foregroundColor(vm.locationManager.state.iconColor)
                        .padding(4)
                }
            }
        }
        .onAppear {
            if vm.weatherData == nil,
               let location = vm.locationManager.lastKnownLocation {
                vm.fetchWeatherFrom(location: location)
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
            WeatherView(weatherData: weatherData, weatherIcon: vm.weatherIcon) {
                if let weatherIcon = vm.weatherIcon {
                    vm.didTransitionToDetail.send((weatherData, weatherIcon))
                }
            }
        }
    }
}

#Preview {
    SearchView(vm: SearchViewModel())
}
