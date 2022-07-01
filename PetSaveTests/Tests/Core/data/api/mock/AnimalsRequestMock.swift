//
//  AnimalsRequestMock.swift
//  PetSaveTests
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

@testable import PetSave

enum AnimalsRequestMock: RequestProtocol {
  case getAnimals
  // 1 Sets the requestType. For this case, it could be anything since this is a mock.
  var requestType: RequestType {
    return .GET
  }
  // 2 Reads the path for AnimalsMock.json in Bundle.main if available. If not, it sets it to an empty string.
  var path: String {
    guard let path = Bundle.main.path(
      forResource: "AnimalsMock", ofType: "json")
    else { return "" }
    return path
  }
}
