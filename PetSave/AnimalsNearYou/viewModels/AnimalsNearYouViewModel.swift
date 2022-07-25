//
//  AnimalsNearYouViewModel.swift
//  PetSave
//
//  Created by David Duarte on 23/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol AnimalsFetcher {
  func fetchAnimals(page: Int) async -> [Animal]
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
  
  func fetchAnimals() async {
    let animals = await animalFetcher.fetchAnimals(page: page)
    do {
      try await animalStore.save(animals: animals)
    } catch {
      print("Error storing animals... \(error.localizedDescription)")
    }
    
    self.isLoading = false
    // If the response from Petfinder’s API returns an empty array of animals, you’ll set this property to false, as that means the list has reached its end.
    hasMoreAnimals = !animals.isEmpty
  }
  
  func fetchMoreAnimals() async {
    page += 1
    await fetchAnimals()
  }
}
