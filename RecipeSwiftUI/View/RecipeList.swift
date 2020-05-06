//
//  RecipeList.swift
//  RecipeSwiftUI
//
//  Created by Atilla Özder on 21.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct RecipeList: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: RecipeListViewModel
    
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
