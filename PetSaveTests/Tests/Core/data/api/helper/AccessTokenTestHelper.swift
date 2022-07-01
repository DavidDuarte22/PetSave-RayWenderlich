//
//  AccessTokenTestHelper.swift
//  PetSaveTests
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

@testable import PetSave

enum AccessTokenTestHelper {
  // 1 Returns a random string of length eight.
  static func randomString() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyz"
    return String(letters.shuffled().prefix(8))
  }
  // 2 Returns a random APIToken using randomString.
  static func randomAPIToken() -> APIToken {
    return APIToken(tokenType: "Bearer", expiresIn: 10,
      accessToken: AccessTokenTestHelper.randomString())
  }
  // 3 Generates random token data similar to the one the apps received from the Petfinder API.
  static func generateValidToken() -> String {
    """
    {
      "token_type": "Bearer",
      "expires_in": 10,
      "access_token": \"\(randomString())\"
    }
    """
  }
}
