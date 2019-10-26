//
//  RecipeListViewModel.swift
//  Tadımlık
//
//  Created by Atilla Özder on 22.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI
import Combine

class RecipeListViewModel: ObservableObject {
    
    @Published var dataSource: [RecipeViewModel] = []
    @Published var isLoading: Bool = true
    
    private var disposables = Set<AnyCancellable>()
    
    var isEmpty: Bool {
        return dataSource.isEmpty
    }
    
    func load() {
        fetchRecipes()
    }

    private func fetchRecipes() {
        ApiService.shared()
            .fetch(with: RecipeRouter.all, decoding: RecipeData.self)
            .map { (response) -> [RecipeViewModel] in
                return response.recipes.map(RecipeViewModel.init)
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
