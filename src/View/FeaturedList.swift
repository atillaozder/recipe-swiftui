//
//  FeaturedList.swift
//  Tadımlık
//
//  Created by Atilla Özder on 19.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct FeaturedList: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: FeaturedViewModel = FeaturedViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                ZStack {
                    LoadingView(isLoading: $viewModel.isLoading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeaturedHRow(viewModel: viewModel)
                        ForEach(viewModel.categories) { viewModel in
                            FeaturedVRow(viewModel: viewModel)
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationBarTitle(Text("Featured"))
            .onAppear(perform: viewModel.load)
        }
    }
}

struct FeaturedList_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedList()
    }
}

struct FeaturedHRow: View {
    
    @ObservedObject var viewModel: FeaturedViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(viewModel.main) { viewModel in
                    NavigationLink(destination: RecipeDetail(viewModel: viewModel)) {
                        RecipeRow(viewModel: viewModel)
                            .frame(width: 380)
                            .clipped()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(height: 200)
            .padding(.allExceptBottom)
        }
    }
}

struct FeaturedVRow: View {
    
    @EnvironmentObject var userData: UserData
    var viewModel: FeaturedCategoryViewModel
    
    var padding: CGFloat {
        return 16
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: padding) {
            NavigationLink(destination: FeaturedCategoryList(viewModel: viewModel)) {
                HStack(alignment: .center) {
                    Text(viewModel.title)
                        .font(.system(size: 22, weight: .semibold))
                        .fixedSize()
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                        .foregroundColor(Color.gray)
                        .font(Font.headline)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            ForEach(viewModel.filteredDataSource) { viewModel in
                NavigationLink(destination: RecipeDetail(viewModel: viewModel)) {
                    HStack(alignment: .center, spacing: 12) {
                        Image(viewModel.image)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 74, height: 74)
                            .clipped()
                            .cornerRadius(16)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.name)
                                .font(.headline)
                                .lineLimit(1)
                            
                            Text(viewModel.category)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                            
                            Text(viewModel.time)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.allExceptBottom)
    }
}

#warning("Duplicate RecipeList")
struct FeaturedCategoryList: View {
    
    @EnvironmentObject var userData: UserData
    var viewModel: FeaturedCategoryViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.viewModel.dataSource) { viewModel in
                    ZStack(alignment: .topTrailing) {
                        NavigationLink(destination: RecipeDetail(viewModel: viewModel)) {
                            RecipeRow(viewModel: viewModel)
                        }
                        .buttonStyle(PlainButtonStyle())

                        FavoriteButton(viewModel: viewModel, color: .white)
                            .padding()
                    }
                }
                .padding(.allExceptBottom)
            }
            .padding(.bottom)
        }
        .navigationBarTitle(Text(viewModel.title), displayMode: .inline)
    }
}
