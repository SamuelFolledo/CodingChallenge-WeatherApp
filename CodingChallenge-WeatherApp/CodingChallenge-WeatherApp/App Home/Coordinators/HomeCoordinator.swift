//
//  HomeRouter.swift
//  FuFight
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import Combine

final class HomeCoordinator: Router<HomeRoute> {
    @Published var route: HomeRoute

    private var id: UUID = UUID()
    private var cancellables = Set<AnyCancellable>()

    init(route: HomeRoute = .locationPermissionNotGranted) {
        self.route = route
    }

    @ViewBuilder func build(locationManager: LocationManager) -> some View {
        if let status = locationManager.authorizationStatus {
            switch status {
            case .notDetermined:
                homeView(locationManager: locationManager)
            case .restricted, .denied:
                VStack {
                    Text("TODO: Location permission is not granted: \(locationManager.authorizationStatus.debugDescription). Go to Settings to update location permission")
                }
            case .authorizedAlways, .authorizedWhenInUse:
                EmptyView()
            default:
                EmptyView()
            }
        }
    }

    @ViewBuilder func homeView(locationManager: LocationManager) -> some View {
        HomeView(vm: self.makeHomeViewModel(locationManager: locationManager))
            .navigationDestination(for: HomeRoute.self) { route in
                let _ = print("Screen is \(route)")
                switch route {
                case .locationPermissionNotGranted:
                    VStack {
                        Text("Home location is not granted")
                    }
                }
            }
    }

    //MARK: - Home Methods
    func makeHomeViewModel(locationManager: LocationManager) -> HomeViewModel {
        let vm = HomeViewModel(locationManager: locationManager)
        return vm
    }
}
