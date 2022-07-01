//
//  APIManagerMock.swift
//  PetSaveTests
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

// 1 Import PetSave using @testable attribute. @testable compiles the module with testing enabled. In this module, the public class or struct and its members now behave like they are open and the ones marked with an internal behave like they are public.
@testable import PetSave

// 2 Create APIManagerMock and make it conform to APIManagerProtocol.
struct APIManagerMock: APIManagerProtocol {
  // 3 Since request is of type RequestProtocol, it has a property path. path will contain the location of the mock file. This function uses this information to get the file and convert its content to Data.
  func perform(_ request: RequestProtocol, authToken: String) async throws -> Data {
    return try Data(contentsOf: URL(fileURLWithPath: request.path), options: .mappedIfSafe)
  }
   // 4 You return a dummy token from here.
  func requestToken() async throws -> Data {
    Data(AccessTokenTestHelper.generateValidToken().utf8)
  }
}
