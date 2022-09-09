//
//  RequestLocationView.swift
//  PetSave
//
//  Created by David Duarte on 5/9/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import SwiftUI
import CoreLocationUI

struct RequestLocationView: View {
  @EnvironmentObject var locationManager: LocationManager

  var body: some View {
    VStack {
      // Adds an image of a dog as a placeholder.
      Image("creature_dog-and-bone")
        .resizable()
        .frame(width: 240, height: 240)
      // A Text that explains why the user has to share their current location.
      Text(
        """
        To find pets near you, first, you need to
        share your current location.
        """
      )
        .multilineTextAlignment(.center)
      // A button to ask the user to share their location. Here, you call startUpdatingLocation to starts tracking the user’s location.
      LocationButton {
        locationManager.requestWhenInUseAuthorization()
      }
      .symbolVariant(.fill)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
    .padding()
    // An onAppear(perform:) view modifier to update the authorization status when the view first appears.
    .onAppear {
      locationManager.updateAuthorizationStatus()
    }
  }

  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }
}

struct RequestLocationView_Previews: PreviewProvider {
  static var previews: some View {
    RequestLocationView()
      .environmentObject(LocationManager())
  }
}
