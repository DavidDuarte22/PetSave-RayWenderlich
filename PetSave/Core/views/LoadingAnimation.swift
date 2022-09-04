//
//  LoadingAnimation.swift
//  PetSave
//
//  Created by David Duarte on 4/9/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import SwiftUI

// LoadingAnimationView is a UIViewRepresentable. There isn’t a good SwiftUI set of widgets to use here, so you’ll use a UIKit component and wrap it in a UIViewRepresentable so SwiftUI can use it.
struct LoadingAnimation: UIViewRepresentable {
  let animatedFrames: UIImage
  let image: UIImageView
  let squareDimension: CGFloat = 125

  // The init method gets this image ready to use.
  init() {
    var images: [UIImage] = []
    // This loop fills the images array with the images required to make the animation. The string format %03d constructs an integer with three digits and leading zeroes. i is the value passed in to construct the integer.
    for i in 1...127 {
      guard let image =
        UIImage(named: "dog_\(String(format: "%03d", i))")
        else { continue }
      images.append(image)
    }
    // To set up animatedFrames you used animatedImage(with:duration:). This is a static method of UIKit’s UIImage that takes in an array of UIImages and a duration and returns an animated image.
    animatedFrames = UIImage.animatedImage(with: images,
      duration: 4) ?? UIImage()
    // Set up image. This is an UIImageView that will act as the container for your animated image.
    image = UIImageView(frame: CGRect(x: 0, y: 0, width: squareDimension, height: squareDimension))
  }

  // makeUIView places the animated image in a UIImageView. The UIImageView goes in a UIView for the UIViewRepresentable to present on screen.
  func makeUIView(context: Context) -> UIView {
    let view = UIView(frame: CGRect(x: 0, y: 0,
      width: squareDimension, height: squareDimension))
    image.clipsToBounds = true
    image.autoresizesSubviews = true
    image.contentMode = .scaleAspectFit
    image.image = animatedFrames
    image.center = CGPoint(x: view.frame.width / 2,
      y: view.frame.height / 2)
    view.backgroundColor = .red
    view.addSubview(image)

    return view
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    // no code here; just for protocol
  }
}

// This is the actual SwiftUI View that uses a LoadingAnimation() inside a VStack.
struct LoadingAnimationView: View {
  var body: some View {
    VStack {
      LoadingAnimation()
    }
  }
}

// The preview provider for your SwiftUI View. So you can see it on Xcode Previews
struct LoadingAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingAnimationView()
  }
}
