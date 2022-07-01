//
//  RequestManagerTests.swift
//  PetSaveTests
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import PetSave

class RequestManagerTests: XCTestCase {
  private var requestManager: RequestManagerProtocol?

  override func setUp() {
    super.setUp()
    // Gets a reference to a UserDefaults instance and removes all its content. It returns early in case of any errors.
    guard let userDefaults = UserDefaults(suiteName: #file) else {
      return
    }

    userDefaults.removePersistentDomain(forName: #file)

    // Initializes requestManager with mock objects.
    requestManager = RequestManager(
      apiManager: APIManagerMock(),
      accessTokenManager: AccessTokenManager(userDefaults: userDefaults)
    )
  }
  
  func testRequestAnimals() async throws {
    // Fetches animals from the local JSON. guard checks that some data is returned and fails the test if any errors occur.
    guard let container: AnimalsContainer =
      try await requestManager?.perform(
        AnimalsRequestMock.getAnimals) else {
        XCTFail("Didn't get data from the request manager")
        return
      }

    let animals = container.animals

    // To keep it simple, tests the first and last animal object.
    let first = animals.first
    let last = animals.last

    // Tests if objects are the same as you expected.
    XCTAssertEqual(first?.name, "Kiki")
    XCTAssertEqual(first?.age.rawValue, "Adult")
    XCTAssertEqual(first?.gender.rawValue, "Female")
    XCTAssertEqual(first?.size.rawValue, "Medium")
    XCTAssertEqual(first?.coat?.rawValue, "Short")

    XCTAssertEqual(last?.name, "Midnight")
    XCTAssertEqual(last?.age.rawValue, "Adult")
    XCTAssertEqual(last?.gender.rawValue, "Female")
    XCTAssertEqual(last?.size.rawValue, "Large")
    XCTAssertEqual(last?.coat, nil)
  }
}
