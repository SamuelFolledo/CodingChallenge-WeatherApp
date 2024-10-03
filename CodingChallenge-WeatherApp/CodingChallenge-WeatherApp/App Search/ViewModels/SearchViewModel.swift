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
    @Published var searchText: String = ""
    @Published var weatherData: WeatherData?
    @Published var weatherIcon: UIImage?
    @Published var locationManager: LocationManager

    let didTransitionToDetail = PassthroughSubject<(WeatherData, UIImage), Never>()

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

    func fetchWeatherFrom(location: Location) {
        print("Fetching weather from location: \(location)")
        updateLoadingMessage(to: "Fetching weather from current location")

        weatherService.fetchWeather(for: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.updateLoadingMessage(to: nil)
                if case .failure(let error) = completion {
                    self?.handleWeatherError(error)
                }
            }, receiveValue: { [weak self] weatherData in
                self?.weatherData = weatherData
                self?.fetchWeatherIcon(named: weatherData.iconName ?? "")
            })
            .store(in: &cancellables)
    }

    func searchWeather(for cityName: String) {
        //TODO: If given more time, do more error handling to make sure cityName is a valid city before fetching for weather data
        //TODO: Errors can be shown by making the search field red
        updateLoadingMessage(to: "Fetching weather for \(cityName)")

        weatherService.fetchWeather(for: cityName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.updateLoadingMessage(to: nil)
                if case .failure(let error) = completion {
                    self?.handleWeatherError(error)
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
                    self?.handleWeatherError(error)
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

    private func handleWeatherError(_ error: WeatherError) {
        //TODO: If given more time, I would have come up with a more types of error and clearer way of handling errors
        updateLoadingMessage(to: nil)
        switch error {
        case .networkError(let error), .decodingError(let error):
            print("TODO Better error handling: \(error.localizedDescription)")
            updateError("Invalid City")
        case .unknown, .invalidURL:
            updateError("Invalid City")
        case .invalidImageData:
            updateError("Error download image")
        }
    }
}
