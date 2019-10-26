//
//  RecipeViewModel.swift
//  Tadımlık
//
//  Created by Atilla Özder on 23.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI
import Combine

class RecipeViewModel: ObservableObject, Identifiable {
    
    @Published private(set) var recipe: Recipe
    
    var name: String {
        return recipe.name
    }
    
    var image: String {
        return recipe.image
    }
    
    var category: String {
        return recipe.category.title
    }
    
    var time: String {
        return recipe.time
    }
    
    var materials: [String] {
        return recipe.materials.components(separatedBy: ",")
    }
    
    var preparation: String {
        return recipe.preparation
    }
    
    var definition: String {
        return recipe.definition
    }
    
    var rate: String {
        return "\(recipe.rate)"
    }
    
    var totalRate: String {
        return NumberFormatter
            .localizedString(from: NSNumber(value: recipe.totalRateCount), number: .decimal)
    }
    
    var userRate: Int {
        return recipe.loggedUserRate ?? 0
    }
    
    var userHasRate: Bool {
        return recipe.loggedUserRate != nil
    }
    
    var userRateText: String {
        return userHasRate ? "Sen" : "Puanla"
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func rate(_ value: Int?) {
        #warning("ApiRequest to rate recipe")
        self.recipe.loggedUserRate = value
    }
}
