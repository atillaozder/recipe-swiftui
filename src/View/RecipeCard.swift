//
//  RecipeCard.swift
//  Tadımlık
//
//  Created by Atilla Özder on 26.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct RecipeCard: View {
    var viewModel: RecipeViewModel
    
    var body: some View {
        Image(viewModel.image)
            .resizable()
            .overlay(TextOverlay(viewModel: viewModel))
            .scaledToFill()
            .frame(height: 300)
    }
}

#if DEBUG
struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(viewModel: .init(recipe: .init()))
            .previewLayout(.sizeThatFits)
    }
}
#endif

struct TextOverlay: View {
    var viewModel: RecipeViewModel
    
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.black.opacity(0.6), Color.black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill(gradient)
            Text(viewModel.name)
                .font(.title)
                .bold()
                .padding()
        }
        .foregroundColor(.white)
    }
}
