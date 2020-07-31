//
//  CollectionViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/19.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "articleCell2"

class CollectionViewController: UICollectionViewController, XMLParserDelegate, RefreshP {
    
    // DB
    fileprivate var realm: Realm?
    fileprivate var realmDB: RealmDB?
    
    var userID: String!
    var userData: [String]!
    var items: [Item]!
    var fontSizeList: [Int]!
    
    let semaphore = DispatchSemaphore(value: 1)
    
    @IBOutlet weak var tableTitle: UINavigationItem!
    
    //@IBOutlet var colView: UICollectionView!
    
    // ログイン画面に戻るボタン
    @IBAction func goBackLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    // 設定ボタン
    @IBAction func toSetting(_ sender: Any) {
        self.performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("--記事一覧画面 CollectionView--")
        self.navigationItem.hidesBackButton = true
        
        tableTitle.title = userData[1]
        self.collectionView.reloadData()
        
        // テスト　DB
        realm = try! Realm()
        
        refreshAction()
    }
    
    func refreshAction() {
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.attributedTitle = NSAttributedString(string: "記事の更新中・・")
        collectionView.refreshControl?.addTarget(self, action: #selector(updateRefresh), for: UIControl.Event.valueChanged)
    }
    
    func updateRefresh() {
        let settings = UserDefaults.standard
        let feedInfo = ListInfo()
        if feedInfo.startDownload(self.userData[2], userID: userID, checkChange: true, view: self) {
            // フィード接続　OK
            let items = feedInfo.items
            self.items = items
            let feedData = try! NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
            
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

        collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare 遷移前")
        if (segue.identifier == "toArticle") {
            if let indexPath = self.collectionView.indexPathsForSelectedItems {
                let item = items[indexPath[0].row]
                let controller = segue.destination as! ArticleViewController
                controller.title = item.title
                //controller.link = item.link
                controller.requestData = item.requestData
            }
        } else if (segue.identifier == "toSetting") {
            let nextView = segue.destination as! ConfigViewController
            nextView.userID = self.userID
            nextView.fontSizeList = self.fontSizeList
        }
    }
    
    // セクション単位
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     // 表示アイテム数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // セルの表示
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
       
        // Tag番号を使いインスタンスを作る
        let cellView = cell.contentView.viewWithTag(0)
        
        if items[indexPath.row].image != nil {
            let cellImage = cellView?.viewWithTag(1) as! UIImageView
            if let image = try? Data(contentsOf: items[indexPath.row].image!) {
                cellImage.image = UIImage(data: image)
            }
        }
        
        let cellLabel = cellView?.viewWithTag(2) as! UILabel
        cellLabel.text = items[indexPath.row].title
        
        Utility.setCollectionViewCellFont(cell: cellLabel, fontSize: fontSizeList[0])
        
        return cell
    }
    
    // セル選択
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toArticle", sender: nil)
    }
}
