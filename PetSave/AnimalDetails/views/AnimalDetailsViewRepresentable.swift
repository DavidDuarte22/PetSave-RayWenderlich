//
//  AnimalDetailsViewRepresentable.swift
//  PetSave
//
//  Created by David Duarte on 4/9/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import UIKit
import SwiftUI

struct AnimalDetailsViewRepresentable: UIViewControllerRepresentable {
  // Creates a variable to receive the name of the animal from the AnimalsNearYouView.
  var name: String
  // Gets the state of the navigation in the current environment.
  @EnvironmentObject var navigationState: NavigationState
  // Assigns the type of the destination view controller. Here, it’s the AnimalDetailsViewController.
  typealias UIViewControllerType = AnimalDetailsViewController
  // This method is from the UIViewControllerRepresentable. Here, you update the changes coming from the SwiftUI view.
  func updateUIViewController(
    _ uiViewController: AnimalDetailsViewController,
    context: Context) {
      // You set the name of the animal and the status of the navigation here.
      uiViewController.set(
        name,
        status: navigationState.isNavigatingDisabled
      )
      // This closure listens to the button inside the AnimalDetailsViewController and toggles the navigation state.
      uiViewController.didSelectNavigation = {
        navigationState.isNavigatingDisabled.toggle()
      }
  }
  // This method is also from UIViewControllerRepresentable. Here, you return the view controller you want SwiftUI to make renderable.
  func makeUIViewController(context: Context)
    -> AnimalDetailsViewController {
      let detailViewController =
        AnimalDetailsViewController(
          nibName: "AnimalDetailsViewController",
          bundle: .main
        )
      return detailViewController
  }
}
