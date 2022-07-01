//
//  AnimalsContainer.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

struct AnimalsContainer: Decodable {
  let animals: [Animal]
  let pagination: Pagination
}
