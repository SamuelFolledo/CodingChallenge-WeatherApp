//
//  PermissionRouter.swift
//  FuFight
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import Combine

final class PermissionCoordinator: Router<PermissionRoute> {
    @Published var route: PermissionRoute

    private var id: UUID = UUID()
    private var cancellables = Set<AnyCancellable>()

    init(route: PermissionRoute = .locationPermissionNotGranted) {
        self.route = route
    }

    @ViewBuilder func build(locationManager: LocationManager) -> some View {
        if let status = locationManager.authorizationStatus {
            switch status {
            case .notDetermined:
                permissionView(locationManager: locationManager)
            case .restricted, .denied:
                VStack {
                    Text("TODO: Location permission is not granted: \(locationManager.authorizationStatus.debugDescription). Go to Settings to update location permission")
                }
            case .authorizedAlways, .authorizedWhenInUse:
                fatalError("Should show SearchView instead")
            default:
                fatalError("Unexpected location authorization status: \(status).")
            }
        }
    }

    @ViewBuilder func permissionView(locationManager: LocationManager) -> some View {
        PermissionView(vm: self.makePermissionViewModel(locationManager: locationManager))
            .navigationDestination(for: PermissionRoute.self) { route in
                let _ = print("Screen is \(route)")
                switch route {
                case .locationPermissionNotGranted:
                    VStack {
                        Text("Permission location is not granted")
                    }
                }
            }
    }

    //MARK: - Permission Methods
    func makePermissionViewModel(locationManager: LocationManager) -> PermissionViewModel {
        let vm = PermissionViewModel(locationManager: locationManager)
//            vm.locationPermissionGranted
//            .receive(on: DispatchQueue.main)
//            .sink(receiveValue: { [weak self] didGrant in
//
//            })
//            .store(in: &cancellables)
        return vm
    }
}
