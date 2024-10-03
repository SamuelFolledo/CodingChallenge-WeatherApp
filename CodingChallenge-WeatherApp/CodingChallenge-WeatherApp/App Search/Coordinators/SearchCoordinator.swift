//
//  SearchCoordinator.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import Combine

final class SearchCoordinator: Router<SearchRoute> {

    private var id: UUID = UUID()

    @ViewBuilder func build(locationManager: LocationManager) -> some View {
        searchView(locationManager: locationManager)
            .navigationDestination(for: SearchRoute.self) { route in
                switch route {
                case .weatherDetail(let weatherData, let image):
                    SearchDetailView(weatherData: weatherData, image: image)
                }
            }
    }

    // MARK: Required methods for class to conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: SearchCoordinator, rhs: SearchCoordinator) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: View Creation Methods
    private func searchView(locationManager: LocationManager) -> some View {
        SearchView(vm: self.makeSearchViewModel(locationManager: locationManager))
    }

    //MARK: - Permission Methods
    func makeSearchViewModel(locationManager: LocationManager) -> SearchViewModel {
        let vm = SearchViewModel(locationManager: locationManager)
        vm.didTransitionToDetail
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (weatherData, image) in
                self?.showWeatherDetail(weatherData, image: image)
            })
            .store(in: &subscriptions)
        return vm
    }
}

// MARK: Navigation Related Extensions
extension SearchCoordinator {
    private func showWeatherDetail(_ weather: WeatherData, image: UIImage) {
        navigationPath.append(.weatherDetail(weatherData: weather, image: image))
    }
}
