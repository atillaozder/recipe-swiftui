//
//  FavoriteList.swift
//  Tadımlık
//
//  Created by Atilla Özder on 20.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct FavoriteList: View {

    @EnvironmentObject var userData: UserData

    var body: some View {
        NavigationView {
            RecipeList(viewModel: RecipeViewModel())
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

//class FavoriteViewModel: RecipeViewModel {
//
//    override init() {
//        super.init()
//    }
//
//    override func load() {
//        self.dataSource = []
//    }
//}

