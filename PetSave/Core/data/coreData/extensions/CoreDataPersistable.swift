//
//  CoreDataPersistable.swift
//  PetSave
//
//  Created by David Duarte on 4/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

protocol UUIDIdentifiable: Identifiable {
  var id: Int? { get set }
}

protocol CoreDataPersistable: UUIDIdentifiable {
  // This protocol uses generics and has an associated type. Associated types are placeholders for the concrete types you’ll pass in later when you adopt this protocol, which will let you bind a value type, struct, with a class type, ManagedType, at compile time.
  associatedtype ManagedType

  // This initializer sets up the object’s basic state.
  init()

  // This initializer takes in the ManagedType object as a parameter. The initializer’s body will handle the conversion from class to struct.
  init(managedObject: ManagedType?)

  // To set values from the managed object to the struct, you need to map key paths in the struct to keys in the managed object. This array stores that mapping.
  var keyMap: [PartialKeyPath<Self>: String] { get }

  // toManagedObject(context:) saves the struct-based object to the Core Data store.
  mutating func toManagedObject(
  context: NSManagedObjectContext) -> ManagedType

  // save(context:) saves the view context to disk, persisting the data.
  func save(context: NSManagedObjectContext) throws
}

// Only types where ManagedType inherits from NSManagedObject can use this extension.
extension CoreDataPersistable
  where ManagedType: NSManagedObject {
  // The initializer takes in an optional ManagedType and calls the class’s default initializer.
  init(managedObject: ManagedType?) {
    self.init()
    // A guard statement checks to confirm the passed in managedObject isn’t nil.
    guard let managedObject = managedObject else { return }

    // For each attribute of the managedObject, the struct stores each KeyPath-Value pair via the storeValue(_: toKeyPath:). This only gets attributes, not relationships.
    for attribute in managedObject.entity.attributesByName {
      if let keyP = keyMap.first(
            where: { $0.value == attribute.key })?.key {
          let value =
      managedObject.value(forKey: attribute.key)
          storeValue(value, toKeyPath: keyP)
      }
    }
  }
  
  private mutating func storeValue(_ value: Any?,
    toKeyPath partial: AnyKeyPath) {
    switch partial {
    case let keyPath as WritableKeyPath<Self, URL?>:
      self[keyPath: keyPath] = value as? URL
    case let keyPath as WritableKeyPath<Self, Int?>:
      self[keyPath: keyPath] = value as? Int
    case let keyPath as WritableKeyPath<Self, String?>:
      self[keyPath: keyPath] = value as? String
    case let keyPath as WritableKeyPath<Self, Bool?>:
      self[keyPath: keyPath] = value as? Bool
    default:
      return
    }
  }
  
  // toManagedObject(context:) is mutating because the id gets saved back in the struct when creating the managed object. This lets you check for existing entries in the database.
  mutating func toManagedObject(context: NSManagedObjectContext =
    PersistenceController.shared.container.viewContext
  ) -> ManagedType {
    let persistedValue: ManagedType
    // This if block checks to see if the struct has a non-nil id value. If so, the code within the if block attempts to fetch that entry from the database. If successful, persistedValue is set to that object. Otherwise, the initializer makes a new object and sets it to persistedValue.
    if let id = self.id {
      let fetchRequest = ManagedType.fetchRequest()
      // This is where you set the predicate for the fetch request. This uses a string with substitution variables and a variadic list of values that replace those arguments. Here, the id is cast to a CVarArg and replaces the %@ in the string.
      fetchRequest.predicate = NSPredicate(
        format: "id = %@", id as CVarArg)
      if let results = try? context.fetch(fetchRequest),
         let firstResult = results.first as? ManagedType {
          persistedValue = firstResult
      } else {
        persistedValue = ManagedType.init(context: context)
        self.id = persistedValue.value(forKey: "id") as? Int
      }
    } else {
      // If the struct’s id is nil, the initializer makes a new object and sets the struct’s id to the managed object’s id.
      persistedValue = ManagedType.init(context: context)
      self.id = persistedValue.value(forKey: "id") as? Int
    }

    return setValuesFromMirror(persistedValue: persistedValue)
  }

  private func setValuesFromMirror(persistedValue: ManagedType) -> ManagedType {
    // Create a mirror of the current struct, self.
    let mirror = Mirror(reflecting: self)
    // Loop over each of the (label, value) pairings in the mirror’s children property.
    for case let (label?, value) in mirror.children {
      // Make a mirror object for the current value in the loop.
      let value2 = Mirror(reflecting: value)
      // Check to make sure the child value isn’t optional, and ensure that the child value’s children collection isn’t empty.
      if value2.displayStyle != .optional || !value2.children.isEmpty {
        // If you make it this far, set the (label, value) pair on the managed object via its setValue(_:, forKey:).
        persistedValue.setValue(value, forKey: label)
      }
    }

    return persistedValue
  }
  
  func save(context: NSManagedObjectContext =
    PersistenceController.shared.container.viewContext) throws {
      try context.save()
  }
}
