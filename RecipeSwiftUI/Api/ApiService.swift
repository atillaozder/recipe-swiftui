//
//  ApiService.swift
//  RecipeSwiftUI
//
//  Created by Atilla Özder on 22.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import Foundation
import Combine

enum ApiError: Error {
    case urlEncoding
    case parsing(_ description: String)
    case response(_ description: String)
}

final class ApiService {
    
    private static let instance: ApiService = .init()
    private let session: URLSession
    
    private init() {
        session = URLSession.shared
    }
    
    static func shared() -> ApiService {
        return instance
    }
    
    func fetch<T>(with request: URLRequestConvertible,
                  decoding type: T.Type) -> AnyPublisher<T, ApiError> where T: Decodable {
        
        #if DEBUG
        if let path = Bundle.main.path(forResource: "recipe", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return decode(data).eraseToAnyPublisher()
            } catch {
                return Fail(error: ApiError.parsing(error.localizedDescription))
                    .eraseToAnyPublisher()
            }
        } else {
            return Fail(error: ApiError.urlEncoding).eraseToAnyPublisher()
        }
        #else
        do {
            let urlRequest = try request.asURLRequest()
            
            return session
                .dataTaskPublisher(for: urlRequest)
                .mapError { (err) in
                    .response(err.localizedDescription)
            }.flatMap(maxPublishers: .max(1)) { (pair) in
                self.decode(pair.data)
            }.eraseToAnyPublisher()
        } catch {
            return Fail(error: ApiError.urlEncoding).eraseToAnyPublisher()
        }
        #endif
    }
    
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, ApiError> {
        let decoder = JSONDecoder()
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { err in
                .parsing(err.localizedDescription)
        }.eraseToAnyPublisher()
    }
}
