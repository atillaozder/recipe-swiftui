//
//  FeaturedList.swift
//  Tadımlık
//
//  Created by Atilla Özder on 19.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

extension Edge.Set {
    static var allExceptBottom: Edge.Set {
        return .init(arrayLiteral: .top, .leading, .trailing)
    }
    
    static var topBot: Edge.Set {
        return .init(arrayLiteral: .top, .bottom)
    }
    
    static var leftRight: Edge.Set {
        return .init(arrayLiteral: .leading, .trailing)
    }
}

extension Color {
    static var background: Color {
        return Color(red: 250/255, green: 250/255, blue: 250/255)
    }
}

extension EdgeInsets {
    static func bottom(_ padding: CGFloat) -> EdgeInsets {
        return .init(top: 0, leading: 0, bottom: padding, trailing: 0)
    }
}

struct FeaturedList: View {
    
    @ObservedObject var viewModel: FeaturedViewModel = FeaturedViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isEmpty {
                LoadingView()
                    .navigationBarTitle(Text("Featured"))
                    .onAppear(perform: viewModel.load)
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    FeaturedHRow(dataSource: viewModel.main)
                    ForEach(viewModel.categories) { viewModel in
                        FeaturedVRow(viewModel: viewModel)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                }
                .navigationBarTitle(Text("Featured"))
            }
        }
    }
}

struct FeaturedList_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedList()
    }
}

struct FeaturedHRow: View {
    
    var dataSource: [RecipeRowViewModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(dataSource) { viewModel in
                    NavigationLink(destination: RecipeDetail(viewModel: viewModel)) {
                        RecipeRow(viewModel: viewModel)
                            .frame(width: 380)
                            .clipped()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.allExceptBottom)
        }
        .frame(height: 200)
    }
}

struct FeaturedVRow: View {
    
    var viewModel: FeaturedCategoryViewModel
    
    var padding: CGFloat {
        return 16
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: padding) {
            NavigationLink(destination: Text(viewModel.title)) {
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
            
            ForEach(viewModel.dataSource) { viewModel in
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
        .padding()
    }
}
