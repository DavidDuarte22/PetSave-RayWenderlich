//
//  NavigationRouter.swift
//  PetSave
//
//  Created by David Duarte on 2/9/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import SwiftUI
protocol NavigationRouter {
  // During the implementation of this protocol, you need to provide the data type you want to pass to the destination view
  associatedtype Data
  // Calling this method inside the view with the appropriate data returns a destination view. It also requires you to pass the state.
  func navigate<T: View>(
    data: Data,
    navigationState: NavigationState,
    view: (() -> T)?
  ) -> AnyView
}
