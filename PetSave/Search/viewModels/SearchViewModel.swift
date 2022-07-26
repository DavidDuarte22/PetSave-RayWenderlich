//
//  SearchViewModel.swift
//  PetSave
//
//  Created by David Duarte on 25/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol AnimalSearcher {
  func searchAnimal(
    by text: String,
    age: AnimalSearchAge,
    type: AnimalSearchType
  ) async -> [Animal]
}

final class SearchViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var ageSelection = AnimalSearchAge.none
  @Published var typeSelection = AnimalSearchType.none

  var shouldFilter: Bool {
    !searchText.isEmpty ||
      ageSelection != .none ||
      typeSelection != .none
  }
  
  private let animalSearcher: AnimalSearcher
  private let animalStore: AnimalStore

  init(animalSearcher: AnimalSearcher, animalStore: AnimalStore) {
    self.animalSearcher = animalSearcher
    self.animalStore = animalStore
  }
  
  func search() {
    Task {
      // start a request passing the text the user typed as a parameter.
      let animals = await animalSearcher.searchAnimal(
        by: searchText,
        age: ageSelection,
        type: typeSelection
      )

      // Save the results in Core Data and handle an error it may throw.
      do {
        try await animalStore.save(animals: animals)
      } catch {
        print("Error storing animals... \(error.localizedDescription)")
      }
    }
  }
  
  func selectTypeSuggestion(_ type: AnimalSearchType) {
    typeSelection = type
    search()
  }

  func clearFilters() {
    typeSelection = .none
    ageSelection = .none
  }
}
