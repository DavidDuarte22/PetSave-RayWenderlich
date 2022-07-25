//
//  AnimalStoreService.swift
//  PetSave
//
//  Created by David Duarte on 23/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import CoreData

struct AnimalStoreService {
  private let context: NSManagedObjectContext

  init(context: NSManagedObjectContext) {
    self.context = context
  }
}

// MARK: - AnimalStore
extension AnimalStoreService: AnimalStore {
  func save(animals: [Animal]) async throws {
    for var animal in animals {
      // transform your animal object into CoreData entities, passing the background context from the service.
      // You must do this because you’re saving animals in the background context and using CoreData to merge changes to the view context.
      animal.toManagedObject(context: context)
    }
    // save the context to persist your changes.
    try context.save()
  }
}
