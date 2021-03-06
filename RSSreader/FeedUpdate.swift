//
//  FeedUpdate.swift
//  RSSreader
//
//  Created by kawada-y on 2020/06/26.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import Foundation

class FeedUpdate: Operation {
    
    static var timer = Timer()
    
    static var userID: String = ""
    static var feedAddress: String = ""
    static var timeInterval: Double! = nil
    static var defaultTimeInterval: Double = 21600      // デフォルト　６時間
    static var repeats: Bool = true
    
    // 初期時
    static func interval (userID: String, feedAddress: String) {
        self.userID = userID
        self.feedAddress = feedAddress
        self.timeInterval = defaultTimeInterval
    }
    
    // 変更時
    static func intervalUpdate (userID: String, feedAddress: String, timeInterval: Double, repeats: Bool) {
        invalidateUpdate()
        self.userID = userID
        self.feedAddress = feedAddress
        self.timeInterval = timeInterval
        self.repeats = repeats
        startUpdate()
    }
    // タイマー
    static func startUpdate () {
        timer = Timer.scheduledTimer(timeInterval: self.timeInterval,
                                     target: self,
                                     selector: #selector(feedUpdate),
                                     userInfo: nil,
                                     repeats: self.repeats)
        timer.fire()
    }
    
    // タイマーの無効
    static func invalidateUpdate () {
        if self.timer.isValid {
            self.timer.invalidate()
        }
    }
    
    // 実行処理
    @objc static func feedUpdate() {
        // グローバルキューで実行
        //DispatchQueue.global().async {
        // 更新処理
        //print(NSDate().description)
        let settings = UserDefaults.standard
        
        let feedInfo = ListInfo()
        if feedInfo.startDownload(self.feedAddress, userID: userID, checkChange: true, view: nil) {
                // フィード接続　OK
                let items = feedInfo.items
                let feedData = try! NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
                
                // 登録ユーザーフィード情報
                var registeredFeedInfo = settings.dictionary(forKey: "feedInfo")
                var userFeedInfo = registeredFeedInfo![userID]
                userFeedInfo = feedData
                registeredFeedInfo![userID] = userFeedInfo
                // 登録ユーザーフィード情報の更新
                settings.set(registeredFeedInfo, forKey: "feedInfo")
            } else {
                // フィード接続　NG
                return
            }
        //}
    }
    
    // バックグラウンド実行
    override func main() {
        
        // バックグラウンド更新処理開始
        //print(NSDate().description)
        
        let settings = UserDefaults.standard
        // mainスレッド処理
        DispatchQueue.main.async {
            let feedInfo = ListInfo()
            
            if feedInfo.startDownload(FeedUpdate.feedAddress, userID: FeedUpdate.userID, checkChange: true, view: nil) {
                // フィード接続　OK
                let items = feedInfo.items
                let feedData = try! NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
                
                //print(FeedUpdate.userID)
                
                // 登録ユーザーフィード情報
                var registeredFeedInfo = settings.dictionary(forKey: "feedInfo")
                var userFeedInfo = registeredFeedInfo![FeedUpdate.userID]
                userFeedInfo = feedData
                registeredFeedInfo![FeedUpdate.userID] = userFeedInfo
                // 登録ユーザーフィード情報の更新
                settings.set(registeredFeedInfo, forKey: "feedInfo")
            } else {
                // フィード接続　NG
                return
            }
        }
    }
}
