//
//  ImageViewRepresentable.swift
//  CodingChallenge-WeatherApp
//
//  Created by Samuel Folledo on 10/3/24.
//

import SwiftUI

struct ImageViewRepresentable: UIViewRepresentable {

    var image: UIImage

    func makeUIView(context: Context) -> some UIView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
