//
//  AppDelegate.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/01.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // タスクに登録
        // 第一引数: Info.plistで定義したIdentifierを指定
        // 第二引数: タスクを実行するキューを指定。nilの場合は、デフォルトのバックグラウンドキューが利用されます。
        // 第三引数: 実行する処理
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "jp.co.illmatics.kawada-y.RSSreader.refresh", using: nil, launchHandler: { task in
            // バックグラウンド処理したい内容
            SceneDelegate.handleAppRefresh(task: task as! BGAppRefreshTask)
        })
        
        return true
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
}
