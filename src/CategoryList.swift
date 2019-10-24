//
//  CategoryList.swift
//  Tadımlık
//
//  Created by Atilla Özder on 24.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct CategoryList: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        GeometryReader { geometry in
            if self.viewModel.isEmpty {
                LoadingView()
                    .frame(width: geometry.size.width)
            } else {
                ScrollView(.vertical, showsIndicators: true) {
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
                    .padding()
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
                    break
                }
            },
            receiveValue: { [weak self] dataSource in
                guard let self = self else { return }
                self.dataSource = dataSource
        })
            .store(in: &disposables)
    }
}
