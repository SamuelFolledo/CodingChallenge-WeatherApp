//
//  SearchCoordinator.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import Combine

final class SearchCoordinator: Router<SearchRoute> {
    @Published var route: SearchRoute

    private var id: UUID = UUID()
    private var cancellables = Set<AnyCancellable>()

    init(route: SearchRoute = .locationGranted) {
        self.route = route
    }

    @ViewBuilder func build(locationManager: LocationManager) -> some View {
        switch self.route {
        case .locationGranted:
//            Text("Location \(self.route)")
            SearchView(vm: self.makeSearchViewModel(locationManager: locationManager))
//        case .locationNotGranted:
//            Text("Location \(self.route)")
//        case .lastSearch:
//            Text("Location \(self.route)")
        case .detail:
            searchDetailView(weatherData: fakeWeatherData)
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

    //MARK: - Home Methods
    func makeSearchViewModel(locationManager: LocationManager) -> SearchViewModel {
        let vm = SearchViewModel(locationManager: locationManager)
        return vm
    }

    private func searchDetailView(weatherData: WeatherData) -> some View {
//        let viewModel = SearchDetailsViewModel(userID: userID ?? 0)
//        let userDetailsView = SearchDetailsView(viewModel: viewModel)
        return SearchDetailView(weatherData: fakeWeatherData)
    }

    // MARK: View Bindings
    //    private func bind(view: SearchsListView) {
    //        view.didClickUser
    //            .receive(on: DispatchQueue.main)
    //            .sink(receiveValue: { [weak self] user in
    //                self?.showWeatherData(for: user)
    //            })
    //            .store(in: &cancellables)
    //    }
}

// MARK: Navigation Related Extensions
extension SearchCoordinator {
    private func showWeatherData(for weather: WeatherData) {
        //        pushCoordinator.send(SearchCoordinator(page: .profile, userID: user.id))
    }
}
