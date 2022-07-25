//
//  AnimalsFetcherMock.swift
//  PetSave
//
//  Created by David Duarte on 23/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

struct AnimalsFetcherMock: AnimalsFetcher {
  func fetchAnimals(page: Int) async -> [Animal] {
    Animal.mock
  }
}
