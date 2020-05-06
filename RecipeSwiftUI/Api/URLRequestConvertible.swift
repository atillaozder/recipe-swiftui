//
//  URLRequestConvertible.swift
//  RecipeSwiftUI
//
//  Created by Atilla Özder on 22.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]
typealias JSON = [String: Any]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

protocol URLRequestConvertible {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var urlParameters: Parameters? { get }
    var bodyParameters: Parameters? { get }
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        guard let url = self.baseURL?.appendingPathComponent(path) else {
            throw ApiError.urlEncoding
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let urlParams = urlParameters {
            if var components = URLComponents(string: url.absoluteString) {
                var urlQueryItems = [URLQueryItem]()
                for param in urlParams {
                    urlQueryItems.append(.init(name: param.key, value: param.value as? String))
                }
                
                components.queryItems = urlQueryItems
                urlRequest = URLRequest(url: components.url!)
            }
        }
        
        if let bodyParams = bodyParameters {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: bodyParams, options: .prettyPrinted)
        }
        
        return urlRequest
    }
}
