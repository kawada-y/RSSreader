//
//  FeedUpdate.swift
//  RSSreader
//
//  Created by kawada-y on 2020/06/26.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import Foundation
import CoreLocation

class FeedUpdate: NSObject, CLLocationManagerDelegate {
    
    var timer = Timer()
    
    var userID: String = ""
    var feedAddress: String = ""
    var updateInterval: Double = 21600      // デフォルト　６時間
    var repeats: Bool = true
    
    // 初期時
    func interval (userID: String, feedAddress: String) {
        self.feedAddress = feedAddress
        startUpdate()
    }
    
    // 変更時
    func intervalUpdate (userID: String, feedAddress: String, updateInterval: Double, repeats: Bool) {
        invalidateUpdate()
        self.feedAddress = feedAddress
        self.updateInterval = updateInterval
        self.repeats = repeats
        startUpdate()
    }
    // タイマー
    func startUpdate () {
        timer = Timer.scheduledTimer(timeInterval: self.updateInterval,
                                     target: self,
                                     selector: #selector(feedUpdate),
                                     userInfo: nil,
                                     repeats: self.repeats)
        timer.fire()
    }
    
    // タイマーの無効
    func invalidateUpdate () {
        self.timer.invalidate()
    }
    
    // 実行処理
    @objc func feedUpdate() {
        let settings = UserDefaults.standard
        //let okButton = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default)
        
        let feedInfo = ListInfo()
        if feedInfo.startDownload(self.feedAddress, view: nil) {
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
    }
}
