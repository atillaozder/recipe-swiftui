//
//  SceneDelegate.swift
//  RecipeSwiftUI
//
//  Created by Atilla Özder on 24.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().allowsSelection = false
        let tCellAppearance = UITableViewCell.appearance()
        tCellAppearance.selectionStyle = .none
        
        let userData = UserData()
        let homeView = HomeView().environmentObject(userData)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: homeView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
