//
//  ListViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController, XMLParserDelegate {
    
    var userID: String!
    var userData: [String]!
    
    //var feedInfo: ListInfo!
    var items: [Item]!
    
    let semaphore = DispatchSemaphore(value: 1)
    
    @IBOutlet weak var tableTitle: UINavigationItem!
    
    // ログイン画面に戻るボタン
    @IBAction func goBackLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    // 設定ボタン
    @IBAction func settingAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("--記事一覧画面 TableView--")
        self.navigationItem.hidesBackButton = true
        
        tableTitle.title = userData[1]
        self.tableView.reloadData()
        
        self.extendedLayoutIncludesOpaqueBars = true //
        
        // リフレッシュ更新
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "記事の更新中・・")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    @objc func refresh() {
        let settings = UserDefaults.standard
        let feedInfo = ListInfo()
        if feedInfo.startDownload(self.userData[2], view: self) {
            // フィード接続　OK
            let items = feedInfo.items
            self.items = items
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
        
        
        semaphore.wait()
        semaphore.signal()
        
        print("リフレッシュ")
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toArticle") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let item = items[indexPath.row]
                let controller = segue.destination as! ArticleViewController
                controller.title = item.title
                //controller.link = item.link
                controller.requestData = item.requestData
            }
        } else if (segue.identifier == "toSetting") {
            let nextView = segue.destination as! ConfigViewController
            nextView.userID = self.userID
        }
    }
}

