//
//  FetchAnimalsService.swift
//  PetSave
//
//  Created by David Duarte on 23/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

struct FetchAnimalsService {
  private let requestManager: RequestManagerProtocol

  init(requestManager: RequestManagerProtocol) {
    self.requestManager = requestManager
  }
}

// MARK: - AnimalFetcher
extension FetchAnimalsService: AnimalsFetcher {
  func fetchAnimals(page: Int,
                    latitude: Double?,
                    longitude: Double?) async -> [Animal] {
    let requestData = AnimalsRequest.getAnimalsWith(
      page: page,
      latitude: latitude,
      longitude: longitude
    )
    do {
      let animalsContainer: AnimalsContainer = try await
        requestManager.perform(requestData)
      return animalsContainer.animals
    } catch {
      print(error.localizedDescription)
      return []
    }
  }
}
