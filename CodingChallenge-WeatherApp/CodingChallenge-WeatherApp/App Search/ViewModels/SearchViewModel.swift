//
//  SearchViewModel.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import CoreLocation
import Combine

class SearchViewModel: BaseViewModel {
    @Published var weatherData: WeatherData?
    @Published var weatherIcon: UIImage?
    @Published var isLoading = false
    @Published var error: WeatherError?
    @Published var showSearchView: Bool = false
    @Published var locationManager: LocationManager

    private let weatherService: WeatherService
    private let imageCacheService: ImageCacheService

    init(weatherService: WeatherService = WeatherService(),
         imageCacheService: ImageCacheService = ImageCacheService(),
         locationManager: LocationManager = LocationManager()) {
        self.weatherService = weatherService
        self.imageCacheService = imageCacheService
        self.locationManager = locationManager
        super.init()
        loadCachedData()
    }

    func fetchWeatherForCurrentLocation(location: Location) {
        isLoading = true

        weatherService.fetchWeather(for: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] weatherData in
                self?.weatherData = weatherData
                self?.fetchWeatherIcon(named: weatherData.iconName ?? "")
            })
            .store(in: &cancellables)
    }

    func searchWeather(for cityName: String) {
        isLoading = true

        weatherService.fetchWeather(for: cityName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] weatherData in
                self?.weatherData = weatherData
                self?.fetchWeatherIcon(named: weatherData.iconName ?? "")
            })
            .store(in: &cancellables)
    }

    private func fetchWeatherIcon(named iconName: String) {
        imageCacheService.getImage(named: iconName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] image in
                self?.weatherIcon = image
            })
            .store(in: &cancellables)
    }

    private func loadCachedData() {
        weatherService.loadCachedWeatherData()
        imageCacheService.loadLastIconName()

        if let lastWeatherData = weatherService.lastWeatherData {
            self.weatherData = lastWeatherData
            if let iconName = lastWeatherData.iconName {
                fetchWeatherIcon(named: iconName)
            }
        }
    }
}
