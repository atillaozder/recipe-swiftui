//
//  UserData.swift
//  Tadımlık
//
//  Created by Atilla Özder on 23.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
            
    @UserDefault("favorites", defaultValue: Set())
    var favorites: Set<Recipe> {
        willSet {
            objectWillChange.send()
        }
    }
        
    func toggleFavorite(_ viewModel: RecipeRowViewModel) {
        if contains(viewModel) {
            favorites.remove(viewModel.recipe)
        } else {
            favorites.insert(viewModel.recipe)
        }
    }
    
    func contains(_ viewModel: RecipeRowViewModel) -> Bool {
        return contains(viewModel.recipe)
    }
    
    private func contains(_ recipe: Recipe) -> Bool {
        return _favorites.wrappedValue.contains(recipe)
    }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard
                let data = UserDefaults.standard.object(forKey: key) as? Data,
                let value = try? JSONDecoder().decode(T.self, from: data)
                else { return defaultValue }
            
            return value
        } set {
            if let value = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(value, forKey: key)
            }
        }
    }
}
