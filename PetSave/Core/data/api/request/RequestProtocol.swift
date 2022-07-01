//
//  RequestProtocol.swift
//  PetSave
//
//  Created by David Duarte on 1/7/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol RequestProtocol {
  // 1 This property is the endpoint usually attached at the end of the base url.
  var path: String { get }

  // 2 These are the headers and params you want to send with the request. The content of params will act as the request’s body.
  var headers: [String: String] { get }
  var params: [String: Any] { get }

  // 3 You’ll use this dictionary to attach query params in the URL.
  var urlParams: [String: String?] { get }

  // 4 This boolean represents if your request needs to add the authorization token.
  var addAuthorizationToken: Bool { get }

  // 5 By adding this, you make all the requests specify their type using RequestType.
  var requestType: RequestType { get }
}

extension RequestProtocol {
  // 1 This is the app’s base URL. Since there is only one, there’s no need to add the protocol definitions.
  var host: String {
    APIConstants.host
  }
  // 2 By default, every request has an authorization token.
  var addAuthorizationToken: Bool {
    true
  }
  // 3 Some requests don’t require params, urlParams and headers, so they have a default value of an empty dictionary.
  var params: [String: Any] {
    [:]
  }

  var urlParams: [String: String?] {
    [:]
  }

  var headers: [String: String] {
    [:]
  }
  
  // 1 Use RequestProtocol.createURLRequest(authToken:) to create the request with an authorization token which throws an error in case of failures like an invalid URL.
  func createURLRequest(authToken: String) throws -> URLRequest {
    // 2 You set up the base components of the URL by setting scheme, host and path.
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path
    // 3 Then you add urlParams to url components if it’s not empty.
    if !urlParams.isEmpty {
      components.queryItems = urlParams.map {
        URLQueryItem(name: $0, value: $1)
      }
    }

    guard let url = components.url
    else { throw NetworkError.invalidURL }

    // 4 Create an URLRequest using url.
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = requestType.rawValue
    // 5 If you need to add any headers to the request, add them to the allHTTPHeaderFields.
    if !headers.isEmpty {
      urlRequest.allHTTPHeaderFields = headers
    }
    // 6 Add an authorization token to the request if addAuthorizationToken is true.
    if addAuthorizationToken {
      urlRequest.setValue(authToken,
        forHTTPHeaderField: "Authorization")
    }
    // 7 The Petfinder API expects data to be of type JSON. So, set the request’s content type to application/json.
    urlRequest.setValue("application/json",
      forHTTPHeaderField: "Content-Type")
    // 8 Finally, you add non-empty parameters to the request as data in the httpBody. Since Petfinder API works with JSON, you serialize the params using NSJSONSerialization.data(withJSONObject:options:).
    if !params.isEmpty {
      urlRequest.httpBody = try JSONSerialization.data(
        withJSONObject: params)
    }

    return urlRequest
  }
}
