//
//  ApiManager.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol APIManagerProtocol {
  func perform(_ request: RequestProtocol, authToken: String) async throws -> Data
   func requestToken() async throws -> Data
}

// 1 Indicates APIManager must conform to APIManagerProtocol.
class APIManager: APIManagerProtocol {
  
  // 2 Creates a private variable to store the URLSession
  private let urlSession: URLSession

  // 3 Passes in the initializer the default shared URLSession. shared provides a singleton that returns a URLSession.
  init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  func perform(_ request: RequestProtocol,
    authToken: String = "") async throws -> Data {
    // 1 URLSession.data(for:) uses async/await to process a request and return data and an URLResponse. Here you used try because it can also throw an error.
    let (data, response) = try await urlSession.data(for: request.createURLRequest(authToken: authToken))
    // 2 You check if the response code is 200. If this condition passes, data is returned.
    guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200
    else {
      // 3 If their response isn’t successful, you return invalidServerResponse. NetworkError is a custom error enumeration and part of the starter project. A custom error enumeration makes it easier to customize the thrown error with meaningful messages.
      throw NetworkError.invalidServerResponse
    }
    return data
  }
  
  func requestToken() async throws -> Data {
    try await perform(AuthTokenRequest.auth)
  }
}
