//
//  ConfigViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // ユーザー情報
    var userID: String!
    var userData: [String]!
    
    fileprivate var items: [Item]!
    // 設定できる項目
    let settingItems: [String] = ["一覧画面の表示切り替え",
                           "RSS取得間隔",
                           "購読RSS管理",
                           "文字サイズ変更"]
    
    // 記事一覧に戻るボタン押下時
    @IBAction func backList(_ sender: Any) {
        let settings = UserDefaults.standard
        let registeredData = settings.dictionary(forKey: "registData")!
        userData = registeredData[userID] as? [String]
        
        // テスト
        print(FeedUpdate.timer.isValid)
        for str in userData {
            print(str)
        }
        print()
        
        let registeredFeedInfo = settings.dictionary(forKey: "feedInfo")!
        let userFeedInfo = registeredFeedInfo[userID] as! Data
        self.items = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userFeedInfo) as! [Item]
        
        if "tableView" == userData[3] {
            self.performSegue(withIdentifier: "toBackTable", sender: self)
        } else if "collectionView" == userData[3]{
            self.performSegue(withIdentifier: "toBackCollection", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.text = settingItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 0: print("表示切り替え")
            self.performSegue(withIdentifier: "toDisplaySetting", sender: nil)
        case 1: self.performSegue(withIdentifier: "toIntervalSetting", sender: nil)
        case 2: self.performSegue(withIdentifier: "toRSSSelect", sender: nil)
        case 3: self.performSegue(withIdentifier: "toFontSetting", sender: nil)
        default: break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let settings = UserDefaults.standard
        let registeredData = settings.dictionary(forKey: "registData")!
        self.userData = registeredData[userID] as? [String]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toBackTable") {
            let nextView = segue.destination as! ListViewController
            nextView.userID = self.userID
            nextView.userData = self.userData
            nextView.items = self.items
        } else if (segue.identifier == "toBackCollection") {
            let nextView = segue.destination as! CollectionViewController
            nextView.userID = self.userID
            nextView.userData = self.userData
            nextView.items = self.items
        } else if (segue.identifier == "toDisplaySetting") {
            let nextView = segue.destination as! DisplaySettingViewController
            nextView.userID = self.userID
            nextView.userData = self.userData
        } else if (segue.identifier == "toIntervalSetting") {
            let nextView = segue.destination as! RSSIntervalViewController
            nextView.userID = self.userID
            nextView.userData = self.userData
        } else if (segue.identifier == "toRSSSelect") {
            let nextView = segue.destination as! RSSSelectViewController
            nextView.userID = self.userID
        } else if (segue.identifier == "toFontSetting") {
        }
    }
}
