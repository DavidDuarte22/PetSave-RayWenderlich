//
//  AnimalsNearYouViewModel.swift
//  PetSave
//
//  Created by David Duarte on 23/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreLocation

protocol AnimalsFetcher {
  func fetchAnimals(
    page: Int,
    latitude: Double?,
    longitude: Double?
  ) async -> [Animal]
}

protocol AnimalStore {
  func save(animals: [Animal]) async throws
}

@MainActor
final class AnimalsNearYouViewModel: ObservableObject {
  // published property for tracking if the view is loading.
  @Published var isLoading: Bool
  @Published var hasMoreAnimals = true
  private(set) var page = 1
  
  private let animalFetcher: AnimalsFetcher
  private let animalStore: AnimalStore

  init(isLoading: Bool = true, animalFetcher: AnimalsFetcher, animalStore: AnimalStore) {
    self.isLoading = isLoading
    self.animalFetcher = animalFetcher
    self.animalStore = animalStore
  }
  
  func fetchAnimals(location: CLLocation?) async {
    isLoading = true
    do {
      // Pass the user’s latitude and longitude from location to the request to fetch animals.
      let animals = await animalFetcher.fetchAnimals(
        page: page,
        latitude: location?.coordinate.latitude,
        longitude: location?.coordinate.longitude
      )

      // Store the animals from the response
      try await animalStore.save(animals: animals)

      // Set hasMoreAnimals to false if the response returned no animals.
      hasMoreAnimals = !animals.isEmpty
    } catch {
      // Catch and print the error fetching animals may cause.
      print("Error fetching animals... \(error.localizedDescription)")
    }
    isLoading = false
  }
  
  func fetchMoreAnimals(location: CLLocation?) async {
    page += 1
    await fetchAnimals(location: location)
  }
}
