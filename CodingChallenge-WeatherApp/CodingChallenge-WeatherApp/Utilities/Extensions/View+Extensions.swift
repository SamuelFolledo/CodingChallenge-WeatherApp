//
//  View+Extensions.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/2/24.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
