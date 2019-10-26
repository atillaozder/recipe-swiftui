//
//  RateRow.swift
//  Tadımlık
//
//  Created by Atilla Özder on 26.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SwiftUI

struct RateRow: View {
    
    @EnvironmentObject var userData: UserData
    @State private var presentRatePicker: Bool = false
    @State private var rate: Int = 0
    
    var viewModel: RecipeViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .center, spacing: 12) {
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
            
            Button(action: {
                self.rate = self.viewModel.userRate
                self.presentRatePicker = true
            }) {
                RateItem(
                    rate: "\(viewModel.userRate)",
                    title: viewModel.userRateText,
                    color: .blue,
                    displayText: viewModel.userHasRate)
            }
            .buttonStyle(PlainButtonStyle())
            
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
            self.popover
        }
    }
    
    var popover: some View {
        VStack(spacing: 16) {
            VStack(spacing: 32) {                
                RecipeCard(viewModel: viewModel)
                
                HStack(alignment: .center, spacing: 6) {
                    ForEach(1...10, id: \.self) { idx in
                        Button(action: {
                            self.rate = idx
                        }) {
                            Image(systemName: idx > self.rate ? "star" : "star.fill")
                                .renderingMode(.template)
                                .foregroundColor(idx > self.rate ? .black : .blue)
                                .font(Font.title.weight(.light))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            if self.rate != 0 {
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
            }
        }
        .padding()
    }
}

struct RateRow_Previews: PreviewProvider {
    static var previews: some View {
        RateRow(viewModel: .init(recipe: .init()))
            .environmentObject(UserData())
            .previewLayout(.sizeThatFits)
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
    var displayText: Bool = true
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: displayText ? "star.fill" : "star")
                .renderingMode(.template)
                .foregroundColor(displayText ? color : Color.gray)
                .font(Font.title.weight(.light))
            
            VStack(alignment: .center, spacing: 2) {
                if displayText {
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
}
