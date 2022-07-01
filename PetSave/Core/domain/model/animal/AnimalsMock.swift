//
//  AnimalsMock.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

// 1 Creates AnimalsMock that represents a response from the Petfinder API and makes it conform to Codable.
private struct AnimalsMock: Codable {
  let animals: [Animal]
}

// 2 Creates a function that loads AnimalsMock.json and tries to decode it to an object of AnimalsMock. Then it returns the array of animals inside that object.
private func loadAnimals() -> [Animal] {
  guard let url = Bundle.main.url(
    forResource: "AnimalsMock",
    withExtension: "json"
  ), let data = try? Data(contentsOf: url) else { return [] }
  let decoder = JSONDecoder()
  // 3 Automatically converts keys stored in the API as snake_case into camelCase. This way the properties in the struct will match the name of the ones in the JSON.
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  let jsonMock = try? decoder.decode(AnimalsMock.self, from: data)
  return jsonMock?.animals ?? []
}

// 4 And finally, creates an extension of Animal to expose this mocked data to the rest of the project.
extension Animal {
  static let mock = loadAnimals()
}
