//
//  RecipeRouter.swift
//  RecipeSwiftUI
//
//  Created by Atilla Özder on 22.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import Foundation

enum RecipeRouter {
    case featured
    case all
}

extension RecipeRouter: URLRequestConvertible {
    
    var baseURL: URL? {
        return URL(string: "BaseURLString" + "api/")
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
    
    var urlParameters: Parameters? {
        return nil
    }
}
