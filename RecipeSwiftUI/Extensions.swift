//
//  Extensions.swift
//  RecipeSwiftUI
//
//  Created by Atilla Özder on 25.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

extension Edge.Set {
    static var allExceptBottom: Edge.Set {
        return .init(arrayLiteral: .top, .leading, .trailing)
    }
    
    static var topBot: Edge.Set {
        return .init(arrayLiteral: .top, .bottom)
    }
    
    static var leftRight: Edge.Set {
        return .init(arrayLiteral: .leading, .trailing)
    }
}

extension Color {
    static var background: Color {
        return Color(red: 250/255, green: 250/255, blue: 250/255)
    }
}

extension EdgeInsets {
    static func bottom(_ padding: CGFloat) -> EdgeInsets {
        return .init(top: 0, leading: 0, bottom: padding, trailing: 0)
    }
}
