//
//  FavoriteList.swift
//  Tadımlık
//
//  Created by Atilla Özder on 20.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

#warning("Duplicate RecipeList")
struct FavoriteList: View {

    @EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: FavoriteViewModel = FavoriteViewModel()

    var body: some View {
        NavigationView {
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
            .navigationBarTitle("Favorites")
        }
    }
}

struct FavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteList()
            .environmentObject(UserData())
    }
}


class FavoriteViewModel: ObservableObject {
    
    @Published var dataSource: [RecipeRowViewModel] = []
    @Published var isLoading: Bool = true
        
    var isEmpty: Bool {
        return dataSource.isEmpty
    }
    
    init() {
        self.load()
    }
    
    func load() {
        self.dataSource = UserData().favorites.map(RecipeRowViewModel.init)
        self.isLoading = false
    }
}

