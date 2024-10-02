//
//  Router.swift
//  FuFight
//
//  Created by Samuel Folledo on 10/1/24.
//

import Combine

class Router<T>: ObservableObject {
    @Published var navigationPath: [T] = []

    var subscriptions = Set<AnyCancellable>()

    //MARK: - Methods

    public func navigateBack() {
        navigationPath.removeLast()
    }

    public func navigateToRoot() {
        navigationPath.removeAll()
    }
}
