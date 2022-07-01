//
//  AccessTokenManagerTests.swift
//  PetSaveTests
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import PetSave

class AccessTokenManagerTests: XCTestCase {
  private var accessTokenManager: AccessTokenManagerProtocol?
  private var requestManager: RequestManagerMock?

  override func setUp() {
    super.setUp()
    guard let userDefaults = UserDefaults(suiteName: #file) else { return }
    userDefaults.removePersistentDomain(forName: #file)
    accessTokenManager = AccessTokenManager(userDefaults: userDefaults)
    guard let accessTokenManager = accessTokenManager else { return }
    requestManager = RequestManagerMock(apiManager: APIManagerMock(), accessTokenManager: accessTokenManager)
  }

  func testRequestToken() async throws {
    guard let token = try await requestManager?.requestAccessToken() else { return }
    XCTAssertFalse(token.isEmpty)
  }

  func testCachedToken() async throws {
    let token = try await requestManager?.requestAccessToken()
    let sameToken = accessTokenManager?.fetchToken()
    XCTAssertEqual(token, sameToken)
  }

  func testRequestNewToken() async throws {
    guard let token = try await requestManager?.requestAccessToken() else { return }
    guard let accessTokenManager = accessTokenManager else { return }
    XCTAssertTrue(accessTokenManager.isTokenValid())
    let exp = expectation(description: "Test token validity after 10 seconds")
    let result = XCTWaiter.wait(for: [exp], timeout: 10.0)
    if result == XCTWaiter.Result.timedOut {
      XCTAssertFalse(accessTokenManager.isTokenValid())
      let newToken = try await requestManager?.requestAccessToken()
      XCTAssertTrue(accessTokenManager.isTokenValid())
      XCTAssertNotEqual(token, newToken)
    } else {
      XCTFail("Test failed.")
    }
  }

  func testRefreshToken() async throws {
    let token = try await requestManager?.requestAccessToken()
    let randomToken = AccessTokenTestHelper.randomAPIToken()
    guard let accessTokenManager = accessTokenManager else { return }
    try accessTokenManager.refreshWith(apiToken: randomToken)
    XCTAssertNotEqual(token, accessTokenManager.fetchToken())
    XCTAssertEqual(randomToken.bearerAccessToken, accessTokenManager.fetchToken())
  }
}
