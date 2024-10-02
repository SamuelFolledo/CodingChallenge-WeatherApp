//
//  WeatherView.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var vm: SearchViewModel
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter city name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Search") {
                    vm.searchWeather(for: searchText)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationBarTitle("Search", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
