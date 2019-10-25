//
//  RecipeDetail.swift
//  Tadımlık
//
//  Created by Atilla Özder on 20.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct RecipeDetail: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var viewModel: RecipeRowViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            self.header
            
            VStack(alignment: .leading, spacing: 14) {
                Text(viewModel.name)
                    .font(Font.title.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(viewModel.definition)
                    .font(.body)
                    .lineLimit(nil)
                    .lineSpacing(6)
                
                Text("Rates")
                    .font(.system(size: 22, weight: .semibold))
                
                RateRow(viewModel: viewModel)
                    .padding(.topBot, 8)
                
                Text("Materials")
                    .font(.system(size: 22, weight: .semibold))
                
                HStack(alignment: .center, spacing: 12) {
                    ForEach(viewModel.materials, id: \.self) { material in
                        Text(material)
                            .font(.system(size: 13))
                            .fixedSize()
                            .foregroundColor(Color.black)
                            .padding(.leftRight, 12)
                            .padding(.topBot, 8)
                            .overlay(
                                Capsule()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(Color.gray)
                        )
                    }
                }
                .padding(.topBot, 8)
                
                Text("Preparation")
                    .font(.system(size: 22, weight: .semibold))
                
                Text(viewModel.preparation)
                    .font(.body)
                    .lineSpacing(6)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    var header: some View {
        GeometryReader { geometry in
            if geometry.frame(in: .global).minY < 0 {
                Image(self.viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                Image(self.viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .offset(y: -geometry.frame(in: .global).minY)
                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
            }
        }
        .frame(maxHeight: 300)
        .frame(height: 300)
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeDetail(viewModel: .init(recipe: .init()))
                .environmentObject(UserData())
                .edgesIgnoringSafeArea(.top)
        }
    }
}

struct RateRow: View {
    
    @EnvironmentObject var userData: UserData
    @State private var presentRatePicker: Bool = false
    @State private var rate: Int = 0
    
    var viewModel: RecipeRowViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: "timer")
                    .renderingMode(.template)
                    .foregroundColor(Color.gray)
                    .font(Font.title.weight(.light))
                
                Text(viewModel.time)
                    .font(.caption)
                    .fixedSize()
            }
            
            Spacer()
            
            RateItem(
                rate: viewModel.rate,
                title: viewModel.totalRate,
                color: .yellow)
            
            Spacer()
            
            RateItem(
                rate: "\(viewModel.userRate)",
                title: viewModel.userRateText,
                color: .blue,
                displayRate: viewModel.userHasRate,
                onDidTap: {
                    self.rate = self.viewModel.userRate
                    self.presentRatePicker = true
            })
            
            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                FavoriteButton(viewModel: viewModel, color: .gray)
                
                Text("Favorite")
                    .font(.footnote)
                    .fixedSize()
                    .foregroundColor(Color.black)
            }
        }
        .popover(isPresented: $presentRatePicker) {
            VStack(spacing: 32) {
                Image(self.viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                
                Text("How many point do you think \(self.viewModel.name) deserves?")
                    .font(.body)
                    .lineLimit(nil)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                
                HStack(alignment: .center, spacing: 6) {
                    ForEach(1...10, id: \.self) { idx in
                        Button(action: {
                            self.rate = idx
                        }) {
                            Image(systemName: idx > self.rate ? "star" : "star.fill")
                                .renderingMode(.template)
                                .foregroundColor(idx > self.rate ? .black : .blue)
                                .font(Font.title.weight(.ultraLight))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
            
            VStack(spacing: 16) {
                Button(action: {
                    self.viewModel.rate(self.rate)
                    self.presentRatePicker = false
                }) {
                    Text("Puanla")
                        .modifier(RateButtonModifier())
                }
                .buttonStyle(PlainButtonStyle())
                
                if self.viewModel.userHasRate {
                    Button(action: {
                        self.viewModel.rate(nil)
                        self.presentRatePicker = false
                    }) {
                        Text("Puanımı Geri Al")
                            .modifier(RateButtonModifier())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct RateButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding(.topBot, 8)
            .padding(.leftRight, 16)
            .frame(width: 300)
            .overlay(
                Capsule()
                    .stroke(lineWidth: 0.5)
        )
            .foregroundColor(Color.primary)
    }
}

struct RateItem: View {
    
    var rate: String
    var title: String
    var color: Color
    
    var displayRate: Bool = true
    var onDidTap: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            self.onDidTap?()
        }) {
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: displayRate ? "star.fill" : "star")
                    .renderingMode(.template)
                    .foregroundColor(displayRate ? color : Color.gray)
                    .font(Font.title.weight(.light))
                
                VStack(alignment: .center, spacing: 2) {
                    if displayRate {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text(rate)
                                .font(.system(size: 22, weight: .bold))
                            
                            Text("/10")
                                .font(.system(size: 16))
                        }
                    }
                    
                    Text(title)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
