//
//  AnimalsRequest.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

// 1 Creates an enum called AnimalsRequest that conforms to RequestProtocol. This enum has two cases: getAnimalsWith(page:latitude:longitude:) and getAnimalsBy(name:age:type:).
enum AnimalsRequest: RequestProtocol {
  case getAnimalsWith(page: Int, latitude: Double?, longitude: Double?)
  case getAnimalsBy(name: String, age: String?, type: String?)
  
  // 2 Makes path return the endpoint to fetch animals from the Petfinder API.
  var path: String {
    "/v2/animals"
  }
  
  // 3 urlParams creates the query parameters depending on the current case. For the first case, it adds page to the query parameters and the latitude and longitude if it exists. For the latter case, it adds name along with age and type if it’s not nil. You also pass random to the sort param so that you can get random results with that location.
  var urlParams: [String: String?] {
    switch self {
    case let .getAnimalsWith(page, latitude, longitude):
      var params = ["page": String(page)]
      if let latitude = latitude {
        params["latitude"] = String(latitude)
      }

      if let longitude = longitude {
        params["longitude"] = String(longitude)
      }
      params["sort"] = "random"
      return params

    case let .getAnimalsBy(name, age, type):
      var params: [String: String] = [:]
      if !name.isEmpty {
        params["name"] = name
      }

      if let age = age {
        params["age"] = age
      }

      if let type = type {
        params["type"] = type
      }
      return params
    }
  }
  // 4
  var requestType: RequestType {
    .GET
  }
}
