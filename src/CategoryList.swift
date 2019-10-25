//
//  CategoryList.swift
//  Tadımlık
//
//  Created by Atilla Özder on 24.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

#warning("Duplicate RecipeList")
struct CategoryList: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: CategoryViewModel
    
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
        .navigationBarTitle(Text(viewModel.categoryName), displayMode: .inline)
    }
}

import Combine

class CategoryViewModel: ObservableObject {
    
    @Published private(set) var dataSource: [RecipeRowViewModel] = []
    @Published var isLoading: Bool = true
    
    private var disposables = Set<AnyCancellable>()
    private var category: Recipe.Category
    
    var categoryName: String {
        return category.title
    }
    
    var isEmpty: Bool {
        return dataSource.isEmpty
    }
    
    init(category: Recipe.Category) {
        self.category = category
        
        #warning("Related EnvironmentObject changes")
        self.load()
    }
    
    func load() {
        fetchRecipes()
    }
    
    private func fetchRecipes() {
        ApiService.shared()
            .fetch(with: RecipeRouter.all, decoding: RecipeData.self)
            .map { (response) -> [RecipeRowViewModel] in
                return response.recipes
                    .filter({ $0.category.rawValue == self.category.rawValue })
                    .map(RecipeRowViewModel.init)
        }
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.dataSource = []
                case .finished:
                    self.isLoading = false
                }
            },
            receiveValue: { [weak self] dataSource in
                guard let self = self else { return }
                self.dataSource = dataSource
        })
            .store(in: &disposables)
    }
}
