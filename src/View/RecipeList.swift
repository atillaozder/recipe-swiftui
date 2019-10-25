//
//  RecipeList.swift
//  Tadımlık
//
//  Created by Atilla Özder on 21.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct RecipeList: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ZStack {
                LoadingView(isLoading: $viewModel.isLoading)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(self.viewModel.dataSource) { viewModel in
                        ZStack(alignment: .topTrailing) {
                            NavigationLink(destination: RecipeDetail(viewModel: viewModel)) {
                                RecipeRow(viewModel: viewModel)
                            }
                            .padding(.bottom, 8)
                            .buttonStyle(PlainButtonStyle())

                            FavoriteButton(viewModel: viewModel, color: .white)
                                .padding()
                        }
                    }
                    .padding(.allExceptBottom)
                }
            }
        }
        .onAppear(perform: viewModel.load)
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeList(viewModel: .init())
                .environmentObject(UserData())
                .navigationBarTitle("List View")
        }
    }
}

struct RecipeRow: View {
    
    var viewModel: RecipeRowViewModel
    
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
