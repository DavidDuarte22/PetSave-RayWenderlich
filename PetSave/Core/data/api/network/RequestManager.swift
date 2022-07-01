//
//  RequestManager.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol RequestManagerProtocol {
  
  func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
  
}

class RequestManager: RequestManagerProtocol {
  
  let apiManager: APIManagerProtocol
  let parser: DataParserProtocol
  let accessTokenManager: AccessTokenManagerProtocol

  // 1 You set up the initializer and set apiManager with a default value.
  init(
  apiManager: APIManagerProtocol = APIManager(),
  parser: DataParserProtocol = DataParser(), // 2 Navigate to Core/data/api/parser, and you’ll see DataParser. It conforms to a protocol DataParserProtocol that implements a method that takes in Data and returns a generic Decodable. Then it uses JSONDecoder to decode Data into a Decodable. Here you simply give the object a default value.
  accessTokenManager: AccessTokenManagerProtocol = AccessTokenManager()
  ) {
    self.apiManager = apiManager
    self.parser = parser
    self.accessTokenManager = accessTokenManager
  }
  
  func perform<T: Decodable>(_ request: RequestProtocol)
    async throws -> T {
    // 1 You get the authentication token and store it in authToken.
    let authToken = try await requestAccessToken()
    // 2 Then, you pass the authentication token to the perform(_:) of the APIManager object to add it to the URLRequest.
    let data = try await apiManager.perform(request,
                                            authToken: authToken)
    
    // 3 You decode and return the result of parsing data into the specific T type.
    let decoded: T = try parser.parse(data: data)
    return decoded
  }
  
  func requestAccessToken() async throws -> String {
    // 0. If the saved token is valid, isTokenValid returns true.
    if accessTokenManager.isTokenValid() {
        return accessTokenManager.fetchToken()
      }
    // 1 If there is no saved token, it fetches the token again. Fetch the token based on the AuthTokenRequest. It returns either a Data object or throws an Error.
    let data = try await apiManager.requestToken()
    // 2 Parse the token and map it to APIToken.
    let token: APIToken = try parser.parse(data: data)
    // 3 Return the authentication token.
    return token.bearerAccessToken
  }

}
