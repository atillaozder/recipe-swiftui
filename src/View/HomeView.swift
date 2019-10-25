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
    
    var body: some View {
        TabView {
            FeaturedList()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Anasayfa")
            }
            
            ExploreView()
                .tabItem {
                    Image(systemName: "safari.fill")
                    Text("Keşfet")
            }

            FavoriteList()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favoriler")
            }

        }
        .font(.headline)
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

