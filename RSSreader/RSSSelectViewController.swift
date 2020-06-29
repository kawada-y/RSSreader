//
//  RSSSelectViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

class RSSSelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let settings = UserDefaults.standard
    var userData: [String]!
    var userID: String!
    var feedTitle: String!
    var feedAddress: String!
    var items: [Item]!
    //var feedInfo: ListInfo!
    
    let feedTitleList = ["Gigazine",
                     "痛いニュース(ﾉ∀`)",
                     "オレ的ゲーム速報＠刃",
                     "窓の社",
                     "WIRED"]
    
    let feedAddressList = ["https://gigazine.net/news/rss_2.0/",
                       "http://blog.livedoor.jp/dqnplus/index.rdf",
                       "http://jin115.com/index.rdf",
                       "https://forest.watch.impress.co.jp/data/rss/1.0/wf/feed.rdf",
                       "https://wired.jp/rssfeeder/"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
        
        // セル表示
        cell.textLabel?.text = feedTitleList[indexPath.row]
        return cell
    }
    
    // セルの選択
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 確認処理
        let alert: UIAlertController = UIAlertController(title: "確認", message: "\(feedTitleList[indexPath.row])でよろしいですか？", preferredStyle: UIAlertController.Style.alert)
        // OKボタン
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            self.feedTitle = self.feedTitleList[indexPath.row]
            self.feedAddress = self.feedAddressList[indexPath.row]
            
            // 登録ユーザー情報
            var registeredData = self.settings.dictionary(forKey: "registData")!
            
            // フィード情報の作成
            let feedInfo = ListInfo()
            
            if feedInfo.startDownload(self.feedAddress, view: self) {
                // フィード接続　OK
                self.items = feedInfo.items
                let feedData = try! NSKeyedArchiver.archivedData(withRootObject: self.items!, requiringSecureCoding: false)
                // 登録するフィード情報
                let registrationFeedInfo: [String:Data] = [self.userID : feedData]
                // 登録ユーザーフィード情報
                if let registeredFeedInfo = self.settings.dictionary(forKey: "feedInfo") {
                    // フィード登録情報有り
                    self.settings.set(registeredFeedInfo.union(registrationFeedInfo), forKey: "feedInfo")
                } else {
                    // フィード登録情報無し
                    self.settings.set(registrationFeedInfo, forKey: "feedInfo")
                }
                
                // 登録するフィード取得間隔情報
                let registrationFeedInterval: [String:Int] = [self.userID: 4]
                // 登録ユーザーフィード取得間隔情報
                if let registeredFeedInterval = self.settings.dictionary(forKey: "feedInterval") {
                    // フィード取得間隔情報有り
                    self.settings.set(registeredFeedInterval.union(registrationFeedInterval), forKey: "feedInterval")
                } else {
                    // フィード取得間隔情報無し
                    self.settings.set(registrationFeedInterval, forKey: "feedInterval")
                }
                let userInterval = FeedUpdate()
                
                userInterval.interval(userID: self.userID, feedAddress: self.feedAddress)
                
                // 登録したユーザー情報（userID）の更新
                self.updateUserData(registeredData[self.userID] as? [String] ?? ["","","",""])
                registeredData[self.userID] = self.userData
                
                // ユーザーの更新情報の登録
                self.settings.set(registeredData, forKey: "registData")
                
                self.performSegue(withIdentifier: "toList", sender: nil)
            } else {
                // フィード接続　NG
                return
            }
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) -> Void in
            
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    // ユーザー情報（userID）の更新
    func updateUserData (_ userData: [String]) {
        self.userData = userData
        self.userData[1] = self.feedTitle
        self.userData[2] = self.feedAddress
        self.userData[3] = "tableView"              // 一覧表示のデフォルト TableView
    }
    
    // 次の画面に渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toList") {
            let nextView: ListViewController = (segue.destination as? ListViewController)!
            nextView.userID = self.userID
            nextView.userData = self.userData
            nextView.items = self.items
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("--フィード選択画面--")
        self.navigationItem.hidesBackButton = true
    }
}
