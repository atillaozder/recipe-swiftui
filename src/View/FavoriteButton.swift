//
//  FavoriteButton.swift
//  RecipeSwiftUI
//
//  Created by Atilla Özder on 23.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct FavoriteButton: View {
    
    @EnvironmentObject var userData: UserData
    var viewModel: RecipeViewModel
    var color: Color
    
    var body: some View {
        Button(action: {
            self.userData.toggleFavorite(self.viewModel)
        }) {
            if self.userData.contains(viewModel) {
                Image(systemName: "suit.heart.fill")
                    .renderingMode(.template)
                    .foregroundColor(Color.red)
                    .font(Font.title.weight(.light))
            } else {
                Image(systemName: "suit.heart")
                    .renderingMode(.template)
                    .foregroundColor(color)
                    .font(Font.title.weight(.light))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(viewModel: .init(recipe: .init()), color: .black)
            .environmentObject(UserData())
            .previewLayout(.sizeThatFits)
    }
}
