//
//  Animal.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

struct Animal: Codable {
  var id: Int?
  let organizationId: String?
  let url: URL?
  let type: String
  let species: String?
  var breeds: Breed
  var colors: APIColors
  let age: Age
  let gender: Gender
  let size: Size
  let coat: Coat?
  let name: String
  let description: String?
  let photos: [PhotoSizes]
  let videos: [VideoLink]
  let status: AdoptionStatus
  var attributes: AnimalAttributes
  var environment: AnimalEnvironment?
  let tags: [String]
  var contact: Contact
  let publishedAt: String?
  let distance: Double?
  var ranking: Int? = 0
  
  var picture: URL? {
    photos.first?.medium ?? photos.first?.large
  }
}

// MARK: - Identifiable
extension Animal: Identifiable {
}
