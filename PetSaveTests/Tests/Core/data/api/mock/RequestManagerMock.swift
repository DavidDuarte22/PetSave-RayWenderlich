//
//  RequestManagerMock.swift
//  PetSaveTests
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import PetSave

class RequestManagerMock: RequestManagerProtocol {
  let apiManager: APIManagerProtocol
  let accessTokenManager: AccessTokenManagerProtocol
  let parser: DataParserProtocol

  init(apiManager: APIManagerProtocol, parser: DataParserProtocol = DataParser(), accessTokenManager: AccessTokenManagerProtocol) {
    self.apiManager = apiManager
    self.parser = parser
    self.accessTokenManager = accessTokenManager
  }

  func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
    let authToken = try await requestAccessToken()
    let data = try await apiManager.perform(request, authToken: authToken)
    let decoded: T = try parser.parse(data: data)
    return decoded
  }

  func requestAccessToken() async throws -> String {
    if accessTokenManager.isTokenValid() {
      return accessTokenManager.fetchToken()
    }

    guard let data = AccessTokenTestHelper.generateValidToken().data(using: .utf8) else { return "" }
    let token: APIToken = try parser.parse(data: data)
    try accessTokenManager.refreshWith(apiToken: token)
    return token.bearerAccessToken
  }
}
