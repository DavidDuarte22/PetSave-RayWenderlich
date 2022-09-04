//
//  PetSaveTabType.swift
//  PetSave
//
//  Created by David Duarte on 4/9/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

enum PetSaveTabType {
  case nearYou
  case search
  
  static func deepLinkType(url: URL) -> PetSaveTabType {
    if url.scheme == "petsave" {
      switch url.host {
      case "nearYou":
        return .nearYou
      case "search":
        return .search
      default:
        return .nearYou
      }
    }
    return .nearYou
  }
}

class PetSaveTabNavigator: ObservableObject {
  // The @Published property informs the UI as soon as its value changes.
  @Published var currentTab: PetSaveTabType =  .nearYou
  // A method to set the different types of tabs.
  func switchTab(to tab: PetSaveTabType) {
    currentTab = tab
  }
}
// Since you’ll be using a custom type you need to conform to Hashable.
extension PetSaveTabNavigator: Hashable {
  static func == (
    lhs: PetSaveTabNavigator,
    rhs: PetSaveTabNavigator
  ) -> Bool {
    lhs.currentTab == rhs.currentTab
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(currentTab)
  }
}
