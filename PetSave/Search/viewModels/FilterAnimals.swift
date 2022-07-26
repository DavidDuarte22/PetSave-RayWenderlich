//
//  FilterAnimals.swift
//  PetSave
//
//  Created by David Duarte on 25/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation
import SwiftUI

struct FilterAnimals {
  // Declare properties for the animals you want to filter, the query from the search bar and the age and type selected.
  let animals: FetchedResults<AnimalEntity>
  let query: String
  let age: AnimalSearchAge
  let type: AnimalSearchType

  // Implement a method called callAsFunction that Swift forwards whenever you call this type like a function.
  func callAsFunction() -> [AnimalEntity] {
    let ageText = age.rawValue.lowercased()
    let typeText = type.rawValue.lowercased()
    // Chain filter(_:) calls to filter animals by name, age and type. First by age, then by type and finally by name.
    return animals.filter {
      if ageText != "none" {
        return $0.age.rawValue.lowercased() == ageText
      }
      return true
    }
    .filter {
      if typeText != "none" {
        return $0.type?.lowercased() == typeText
      }
      return true
    }
    .filter {
      if query.isEmpty {
        return true
      }
      return $0.name?.contains(query) ?? false
    }
  }
}
