//
//  ViewModel.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import Combine
import Foundation

protocol ViewModel: ObservableObject {
    ///Called when view appears
    func onAppear()
    ///Called when view disappears
    func onDisappear()
}

class BaseViewModel: ViewModel {
    var dismissAction: (() -> Void)?
    @Published var isAlertPresented: Bool = false
    private(set) var alertTitle = ""
    private(set) var alertMessage = ""
    ///Set this to nil in order to remove this global loading indicator, empty string will show it but have empty message
    @Published private(set) var loadingMessage: String? = nil
    var cancellables = Set<AnyCancellable>()

    //MARK: - ViewModel Overrides

    func onAppear() { }

    func onDisappear() { }

    ///Presents an alert if title or message is not nil
    func updateError(_ title: String? = nil, message: String? = nil) {
        updateLoadingMessage(to: nil)
        if let title {
            updateAlert(title, message: message)
        }
        DispatchQueue.main.async {
            let titleHasValue = !(title ?? "").isEmpty
            self.isAlertPresented = titleHasValue
        }
    }

    func updateLoadingMessage(to message: String?) {
        DispatchQueue.main.async {
            self.loadingMessage = message
        }
    }

    func dismissView() {
        dismissAction?()
    }
}

private extension BaseViewModel {
    func updateAlert(_ title: String, message: String?) {
        alertTitle = title
        if let message {
            alertMessage = message
        }
    }
}
