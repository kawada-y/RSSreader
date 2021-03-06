//
//  ListViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

//import Foundation
import UIKit
import RealmSwift

class ListViewController: UITableViewController, XMLParserDelegate, RefreshP {
    
    // DB
    fileprivate var realm: Realm?
    fileprivate var realmDB: RealmDB?
    
    var userID: String!
    var userData: [String]!
    var items: [Item]!
    var fontSizeList: [Int]!
    
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
        Utility.setTableViewCellFont(cell: cell, fontSize: fontSizeList[0])
        return cell
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("--記事一覧画面 TableView--")
        self.navigationItem.hidesBackButton = true
        
        tableTitle.title = userData[1]
        self.tableView.reloadData()
        
        // テスト　DB
        realm = try! Realm()
        
        // リフレッシュ更新
        refreshAction()
    }
    
    func refreshAction() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "記事の更新中・・")
        self.refreshControl?.addTarget(self, action: #selector(updateRefresh), for: UIControl.Event.valueChanged)
    }
    
    //
    @objc func updateRefresh() {
        let settings = UserDefaults.standard
        let feedInfo = ListInfo()
        if feedInfo.startDownload(self.userData[2], userID: userID, checkChange: true, view: self) {
            // フィード接続　OK
            let udItems = feedInfo.items
            self.items = udItems
            let feedData = try! NSKeyedArchiver.archivedData(withRootObject: udItems, requiringSecureCoding: false)
            
            let userDB = realm?.objects(RealmDB.self).filter("userID == '\(self.userID!)'")
            
            // Realm DB
            self.realmDB = feedInfo.realmDB
            self.realmDB?.userID = self.userID
            
            let realm = try! Realm()
            var number = 0
            try! realm.write {
                for realmItem in self.realmDB!.items {
                    var check = false
                    for userItem in userDB![0].items {
                        if realmItem.title == userItem.title {
                            check = true
                            break;
                        }
                    }
                    if (!check) {
                        //userDB![0].items.append(realmItem)
                        userDB![0].items.insert(realmItem, at: number)
                        number += 1
                    }
                }
            }
            
            self.items = [Item]()
            for item in userDB![0].items {
                let ob = Item()
                ob.title = item.title
                ob.link = item.link
                ob.image = URL(string: item.image ?? "")
                let url = URL(string: item.requestData!)
                ob.requestData = URLRequest(url: url!)
                
                self.items.append(ob)
            }
            
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

        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toArticle") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let item = items[indexPath.row]
                let controller = segue.destination as! ArticleViewController
                controller.title = item.title
                controller.requestData = item.requestData
            }
        } else if (segue.identifier == "toSetting") {
            let nextView = segue.destination as! ConfigViewController
            nextView.userID = self.userID
            nextView.fontSizeList = self.fontSizeList
        }
    }
}

