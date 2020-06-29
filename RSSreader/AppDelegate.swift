//
//  AppDelegate.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/01.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window?.rootViewController = UINavigationController(rootViewController: LoginViewController.self as! ViewController)
        //self.window?.makeKeyAndVisible()
        return true
    }
}

