//
//  AppDelegate.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/01.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit
import BackgroundTasks


// サンプル
class Sample: Operation {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    override func main() {
        print("サンプル表示")
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 説明引用
        // 第一引数: Info.plistで定義したIdentifierを指定
        // 第二引数: タスクを実行するキューを指定。nilの場合は、デフォルトのバックグラウンドキューが利用されます。
        // 第三引数: 実行する処理
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "jp.co.illmatics.kawada-y.RSSreader.refresh", using: nil) { task in
            // バックグラウンド処理したい内容 ※後述します
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }
    
    private func scheduleAppRefresh() {
        // Info.plistで定義したIdentifierを指定
        let request = BGProcessingTaskRequest(identifier: "jp.co.illmatics.kawada-y.RSSreader.refresh")
        // 通信が発生するか否かを指定
        request.requiresNetworkConnectivity = true
        // CPU監視の必要可否を設定
        request.requiresExternalPower = true
        // 最低で、どの程度の期間を置いてから実行するか指定
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            // スケジューラーに実行リクエストを登録
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("スケジュールエラー：\(error)")
        }
    }
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        // 1日の間、何度も実行したい場合は、1回実行するごとに新たにスケジューリングに登録します
        scheduleAppRefresh()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        // 時間内に実行完了しなかった場合は、処理を解放します
        // バックグラウンドで実行する処理は、次回に回しても問題ない処理のはずなので、これでOK
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        // サンプルをキューに詰める
        let array = [1,2,3,4,5]
        array.enumerated().forEach { arg in
            let (offset, value) = arg
            let operation = Sample(id: value)
            if offset == array.count - 1 {
                operation.completionBlock = {
                    // 最後の処理が完了したら、必ず完了したことを伝える必要があります
                    task.setTaskCompleted(success: operation.isFinished)
                }
            }
            queue.addOperation(operation)
        }
    }
}
