//
//  AnimalSearcherMock.swift
//  PetSave
//
//  Created by David Duarte on 25/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

struct AnimalSearcherMock: AnimalSearcher {
  func searchAnimal(
    by text: String,
    age: AnimalSearchAge,
    type: AnimalSearchType
  ) async -> [Animal] {
    var animals = Animal.mock
    if age != .none {
      animals = animals.filter {
        $0.age.rawValue.lowercased() == age.rawValue.lowercased()
      }
    }
    if type != .none {
      animals = animals.filter {
        $0.type.lowercased() == type.rawValue.lowercased()
      }
    }
    return animals.filter { $0.name.contains(text) }
  }
}
