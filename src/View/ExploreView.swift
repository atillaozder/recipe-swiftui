//
//  ExploreView.swift
//  Tadımlık
//
//  Created by Atilla Özder on 19.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
    
    @EnvironmentObject var userData: UserData
    private var categories = Recipe.Category.grouping
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(categories.keys.sorted(), id: \.self) { key in
                        HStack(alignment: .top, spacing: 16) {
                            Spacer()
                            ForEach(self.categories[key]!, id: \.rawValue) { category in
                                NavigationLink(destination: CategoryList(viewModel: .init(category: category))) {
                                    VStack(alignment: .center, spacing: 12) {
                                        category.asImage
                                        Text(category.title)
                                            .font(.footnote)
                                    }
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
                .navigationBarTitle("Categories")
            }
        }
    }
    
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
            .environmentObject(UserData())
    }
}
