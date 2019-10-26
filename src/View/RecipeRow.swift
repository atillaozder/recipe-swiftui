//
//  RecipeRow.swift
//  Tadımlık
//
//  Created by Atilla Özder on 26.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct RecipeRow: View {
    
    var viewModel: RecipeViewModel
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(viewModel.image)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .background(Color.gray)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.1)
            )
            
            Rectangle()
                .frame(height: 200)
                .opacity(0.25)
                .blur(radius: 10)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.name)
                    .foregroundColor(Color.white)
                    .font(Font.largeTitle.weight(.semibold))
                    .lineLimit(2)
                
                Text(viewModel.category)
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .lineLimit(1)
            }
            .padding()
        }
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(viewModel: .init(recipe: .init()))
            .previewLayout(.sizeThatFits)
    }
}
