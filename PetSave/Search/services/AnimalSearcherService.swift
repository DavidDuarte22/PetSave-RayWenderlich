//
//  AnimalSearcherService.swift
//  PetSave
//
//  Created by David Duarte on 25/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

struct AnimalSearcherService {
  let requestManager: RequestManagerProtocol
}

// MARK: - AnimalSearcher
extension AnimalSearcherService: AnimalSearcher {
  func searchAnimal(
    by text: String,
    age: AnimalSearchAge,
    type: AnimalSearchType
  ) async -> [Animal] {
    // create requestData passing the text, age and type.
    // If age or type are not selected, you don’t pass those values in the request.
    let requestData = AnimalsRequest.getAnimalsBy(
      name: text,
      age: age != .none ? age.rawValue : nil,
      type: type != .none ? type.rawValue : nil
    )
    // make a request with the given data and return an array of animals.
    do {
      let animalsContainer: AnimalsContainer = try await requestManager
        .perform(requestData)
      return animalsContainer.animals
    } catch {
      print(error.localizedDescription)
      return []
    }
  }
}
