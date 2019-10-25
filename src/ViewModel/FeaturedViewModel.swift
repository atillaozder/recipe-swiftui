//
//  FeaturedViewModel.swift
//  Tadımlık
//
//  Created by Atilla Özder on 22.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI
import Combine

class FeaturedViewModel: ObservableObject {
    
    @Published var main: [RecipeRowViewModel] = []
    @Published var categories: [FeaturedCategoryViewModel] = []
    @Published var isLoading: Bool = true

    private var disposables = Set<AnyCancellable>()
    
    var isEmpty: Bool {
        return main.isEmpty
    }
    
    func load() {
        fetchRecipes()
    }
    
    private func fetchRecipes() {
        ApiService.shared()
            .fetch(with: RecipeRouter.all, decoding: RecipeData.self)
            .map { (response) -> (main: [RecipeRowViewModel], categories: [FeaturedCategoryViewModel]) in
                let main = response.featured.main.map(RecipeRowViewModel.init)
                let categories = response.featured.categories.map(FeaturedCategoryViewModel.init)
                return (main, categories)
        }
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.main = []
                    self.categories = []
                case .finished:
                    self.isLoading = false
                }
            },
            receiveValue: { [weak self] pair in
                guard let self = self else { return }
                self.main = pair.main
                self.categories = pair.categories
        })
            .store(in: &self.disposables)
    }
}

class FeaturedCategoryViewModel: Identifiable {
    private var featuredCategory: FeaturedCategory
    
    var dataSource: [RecipeRowViewModel]
    var filteredDataSource: [RecipeRowViewModel]
    var title: String {
        return featuredCategory.categoryName
    }
    
    init(featuredCategory: FeaturedCategory) {
        self.featuredCategory = featuredCategory
        self.dataSource = featuredCategory.items.map(RecipeRowViewModel.init)
        self.filteredDataSource = Array(dataSource[0...2])
    }
}
