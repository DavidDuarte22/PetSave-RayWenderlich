//
//  AuthTokenRequest.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

// 1 Declare an enum called AuthTokenRequest that conforms to RequestProtocol and has one case auth.
enum AuthTokenRequest: RequestProtocol {
  case auth
  // 2 Add path, which returns the endpoint to fetch the token.
  var path: String {
    "/v2/oauth2/token"
  }
  // 3 Implement params and assign a key-value with the credentials to make the request. Make sure to update clientId and clientSecret in APIConstants.swift with your keys.
  var params: [String: Any] {
    [
      "grant_type": APIConstants.grantType,
      "client_id": APIConstants.clientId,
      "client_secret": APIConstants.clientSecret
    ]
  }
  // 4 Since it’s the authentication token fetch request itself, addAuthorizationToken is false.
  var addAuthorizationToken: Bool {
    false
  }
  // 5 For this request, requestType needs to be POST.
  var requestType: RequestType {
    .POST
  }
}
