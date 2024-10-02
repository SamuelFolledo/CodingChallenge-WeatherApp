//
//  ImageCacheService.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/1/24.
//

import SwiftUI
import Combine

class ImageCacheService: ObservableObject {
    private let cache = NSCache<NSString, UIImage>()
    private let baseURL = "https://openweathermap.org/img/wn/"
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    @Published var lastIconName: String?

    init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("WeatherIcons")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }

    func getImage(named iconName: String) -> AnyPublisher<UIImage, WeatherError> {
        if let cachedImage = cache.object(forKey: NSString(string: iconName)) {
            return Just(cachedImage)
                .setFailureType(to: WeatherError.self)
                .eraseToAnyPublisher()
        }

        let fileURL = cacheDirectory.appendingPathComponent("\(iconName).png")
        if let imageData = try? Data(contentsOf: fileURL),
           let image = UIImage(data: imageData) {
            cache.setObject(image, forKey: NSString(string: iconName))
            return Just(image)
                .setFailureType(to: WeatherError.self)
                .eraseToAnyPublisher()
        }

        guard let url = URL(string: "\(baseURL)\(iconName).png") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw WeatherError.invalidImageData
                }
                return image
            }
            .mapError { error -> WeatherError in
                if let error = error as? WeatherError {
                    return error
                } else {
                    return .networkError(error)
                }
            }
            .handleEvents(receiveOutput: { [weak self] image in
                self?.cache.setObject(image, forKey: NSString(string: iconName))
//                try? data.write(to: fileURL)
                self?.lastIconName = iconName
            })
            .eraseToAnyPublisher()
    }

    func loadLastIconName() {
        lastIconName = UserDefaults.standard.string(forKey: "lastIconName")
    }

    private func saveLastIconName(_ iconName: String) {
        UserDefaults.standard.set(iconName, forKey: "lastIconName")
        lastIconName = iconName
    }
}
