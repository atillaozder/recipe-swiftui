//
//  HomeView.swift
//  Tadımlık
//
//  Created by Atilla Özder on 18.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userData: UserData
    @State private var selection = 0
    
    private enum Tab: Int {
        case home, explore, favorite
    }
    
    var body: some View {
        TabView(selection: $selection) {
            FeaturedList()
                .tabItem {
                    Image(systemName: "house.fill")
                        .imageScale(.large)
                    Text("Anasayfa")
            }.tag(Tab.home.rawValue)

            ExploreView()
                .tabItem {
                    Image(systemName: "safari.fill")
                        .imageScale(.large)
                    Text("Keşfet")
            }.tag(Tab.explore.rawValue)

            FavoriteList()
                .tabItem {
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                    Text("Favoriler")
            }.tag(Tab.favorite.rawValue)

        }
        .accentColor(.black)
        .edgesIgnoringSafeArea(.top)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserData())
    }
}

