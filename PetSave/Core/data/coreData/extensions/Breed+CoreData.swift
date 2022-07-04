//
//  Breed+CoreData.swift
//  PetSave
//
//  Created by David Duarte on 4/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

// This is an extension of the Breed struct and adopts CoreDataPersistable.
extension Breed: CoreDataPersistable {
  // This is the key map connecting those keyPaths in Breed with the keys from the managed object.
  var keyMap: [PartialKeyPath<Breed>: String] {
    [
      \.primary: "primary",
      \.secondary: "secondary",
      \.mixed: "mixed",
      \.unknown: "unknown",
      \.id: "id"
    ]
  }

  // The managed type for Breed is BreedEntity.
  typealias ManagedType = BreedEntity
}
