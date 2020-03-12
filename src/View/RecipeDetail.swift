//
//  RecipeDetail.swift
//  RecipeSwiftUI
//
//  Created by Atilla Özder on 20.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct RecipeDetail: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            self.header
            
            VStack(alignment: .leading, spacing: 14) {
                Text(viewModel.name)
                    .font(Font.title.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(viewModel.definition)
                    .font(.body)
                    .lineLimit(nil)
                    .lineSpacing(6)
                
                Text("Rates")
                    .font(.system(size: 22, weight: .semibold))
                
                RateRow(viewModel: viewModel)
                    .padding(.topBot, 8)
                
                Text("Materials")
                    .font(.system(size: 22, weight: .semibold))
                
//                HStack(alignment: .center, spacing: 12) {
//                    ForEach(viewModel.materials, id: \.self) { material in
//                        Text(material)
//                            .font(.system(size: 13))
//                            .fixedSize()
//                            .foregroundColor(Color.black)
//                            .padding(.leftRight, 12)
//                            .padding(.topBot, 8)
//                            .overlay(
//                                Capsule()
//                                    .stroke(lineWidth: 1)
//                                    .foregroundColor(Color.gray)
//                        )
//                    }
//                }
//                .padding(.topBot, 8)
                
                Text("Preparation")
                    .font(.system(size: 22, weight: .semibold))
                
                Text(viewModel.preparation)
                    .font(.body)
                    .lineSpacing(6)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    var header: some View {
        GeometryReader { geometry in
            if geometry.frame(in: .global).minY < 0 {
                Image(self.viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                Image(self.viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .offset(y: -geometry.frame(in: .global).minY)
                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
            }
        }
        .frame(maxHeight: 300)
        .frame(height: 300)
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeDetail(viewModel: .init(recipe: .init()))
                .environmentObject(UserData())
                .edgesIgnoringSafeArea(.top)
        }
    }
}
