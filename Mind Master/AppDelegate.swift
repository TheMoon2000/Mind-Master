//
//  AppDelegate.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let menu = MainMenu()
        let nav = TintedNavigationController(rootViewController: menu)
        nav.modalPresentationStyle = .fullScreen
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        PlayerRecord.read()
        
        return true
    }


}

