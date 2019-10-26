//
//  Recipe.swift
//  Tadımlık
//
//  Created by Atilla Özder on 20.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct RecipeData: Decodable {
    let featured: Featured
    let recipes: [Recipe]
}

struct Featured: Decodable {
    let main: [Recipe]
    let categories: [FeaturedCategory]
}

struct FeaturedCategory: Decodable {
    let categoryName: String
    let items: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
        case items
    }
}

struct Recipe: Identifiable, Hashable, Codable {
    let id: Int
    let name, image, time: String
    let materials, definition, preparation: String
    var rate, totalRateCount: Double
    let category: Recipe.Category
    
    var loggedUserRate: Int? {
        willSet {
            var totalRate = self.rate * self.totalRateCount

            if let newRate = newValue {
                if let previousRate = loggedUserRate {
                    totalRate -= Double(previousRate)
                } else {
                    totalRateCount += 1
                }
                
                totalRate += Double(newRate)
            } else {
                if let previousRate = loggedUserRate {
                    totalRate -= Double(previousRate)
                }
                totalRateCount -= 1
            }
            
            let value = totalRate / totalRateCount
            self.rate = round(value * 10) / 10
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, name, image, time, rate
        case materials, definition, preparation
        case category
        case totalRateCount = "total_rate"
        case loggedUserRate = "user_rate"
    }
    
    enum Category: String, CaseIterable, Hashable, Codable {
        case soup
        case meat
        case fish
        case pizza
        case sandwich
        case pasta
        case salad
        case vegan
        case hamburger
        case drink
        case cake
        case fruit
        case dessert
        case vegetables
        case snack
        
        var asImage: Image {
            return .init(self.rawValue)
        }
        
        var title: String {
            return self.rawValue.capitalized(with: .current)
        }
        
        static var grouping: [Int: [Category]] {
            return [
                0: [.meat, .fish, .vegan],
                1: [.salad, .fruit, .vegetables],
                2: [.pizza, .hamburger, .sandwich],
                3: [.soup, .pasta, .snack],
                4: [.dessert, .cake, .drink]
            ]
        }
    }
    
    init() {
        self.id = 0
        self.name = "Crispy Fried Chicken"
        self.category = .meat
        self.image = "food_chicken"
        self.materials = "Beer Batter, Chicken, Baked BBQ Fried Chicken"
        self.definition = "It's the all-American meal. Find out how to make juicy fried chicken with a crispy golden crust every time."
        self.preparation = "This is how to get breading to stay on chicken. Set up a dredging station to minimize mess and make cleanup easy. Put your ingredients and mixtures into large shallow bowls or baking dishes. Then work in one direction (left to right, for example), moving from seasoned flour to egg batter over to bread crumbs/panko/coating mixture. This dry-wet-dry method helps the ingredients stick to the chicken pieces. Have one wet hand and one dry hand -- and use your wet hand to transfer chicken from the wet mixture to the coating bowl. Place the coated chicken on the parchment- or wax paper-lined baking sheet. Before easing the coated chicken pieces into hot fat, allow them to rest, which will give the coating a chance to adhere. Do this step in the refrigerator if you won't be frying the chicken within half an hour. (Allow the cold chicken to come to room temperature before frying or the oil temperature will drop and the chicken will cook unevenly and the coating won't get crispy.)"
        self.time = "15dk"
        self.rate = 8.2
        self.loggedUserRate = 8
        self.totalRateCount = 112525
    }
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
}
