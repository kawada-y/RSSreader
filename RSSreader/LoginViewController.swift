//
//  LoginViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    // Realm (DB) テスト
    
    
    /*
     情報
     
     registData
     → 0 = パスワード
     → 1 = 表示一覧のタイトル
     → 2 = フィードアドレス
     → 3 = 一覧の表示方法 (table or collection)
     
     feedInfo
     → フィードの記事情報
     
     feedInterval
     → 記事を更新するタイミング
     
     fontSize
     → 0 = 記事一覧の文字サイズ
     → 1 = その他の文字サイズ
     */
    
    // DB
    var realm: Realm?
    
    // ユーザー事に登録されている内容      registData
    fileprivate let userSetting: [String:Int] = ["password": 0,
                                     "feedTitle": 1,
                                     "feedAddress": 2,
                                     "displaySelect": 3
    ]
    // ユーザー情報
    fileprivate var userData: [String]!
    // 選択フィード情報
    fileprivate var items = [Item]()
    // フォントサイズ
    fileprivate var fontSizeList: [Int]! = [4,4]
    
    @IBOutlet weak var userloginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // 表示ラベル
    // ラベル「ログインID」
    @IBOutlet weak var label_loginID: UILabel!
    // ラベル「パスワード」
    @IBOutlet weak var label_password: UILabel!
    // ラベル「ログイン」
    @IBOutlet weak var label_loginButton: UIButton!
    
    // 新規登録ボタン
    @IBAction func registrationAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toRegistration", sender: self)
    }
    
    // ログインボタン
    @IBAction func loginAction(_ sender: Any) {
        let alert: UIAlertController
        let okButton = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default)
        
        let settings = UserDefaults.standard
        // 登録情報が有無
        if let registeredData = settings.dictionary(forKey: "registData") {
            
            if userloginField.text!.isEmpty {
                alert = UIAlertController(title: "チェック", message: "ユーザーIDが未入力です", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(okButton)
                self.present(alert, animated: true)
                return
            }
            
            if passwordField.text!.isEmpty {
                alert = UIAlertController(title: "チェック", message: "パスワードが未入力です", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(okButton)
                self.present(alert, animated: true)
                return
            }
            
            guard let registeredUserdata = registeredData[userloginField.text!] else {
                // ユーザーID非該当
                alert = UIAlertController(title: "チェック", message: "ユーザーIDが存在しません", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(okButton)
                self.present(alert, animated: true)
                return
            }
            userData = registeredUserdata as? [String]
            guard passwordField.text! == userData[userSetting["password"]!] else {
                alert = UIAlertController(title: "チェック", message: "パスワードが一致しません", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(okButton)
                self.present(alert, animated: true)
                return
            }
            
            // OKボタン
            let closeAction: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) -> Void in
                
                self.performSegue(withIdentifier: "toRSSSelect", sender: self)
            })
            // フィード情報
            if let registeredFeedInfo = settings.dictionary(forKey: "feedInfo") {
                // フィード情報有り
                if let feedInfo = registeredFeedInfo[userloginField.text!] as? Data {
                    // フィード登録に情報有り
                    //self.items = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(feedInfo) as! [Item]
                    // フォントサイズ設定の取得
                    if let registeredFontSize = settings.dictionary(forKey: "fontSize") {
                        fontSizeList = registeredFontSize[userloginField.text!] as? [Int]
                    }
                    
                    // RealmDB テスト　ここから
                    let realmDB = realm?.objects(RealmDB.self).filter("userID == '\(userloginField.text!)'")
                    
                    print(realmDB![0].userID!)
                    print(realmDB![0].items.count)
                    
                    var ii = [Item]()
                    
                    for item in realmDB![0].items {
                        let ob = Item()
                        ob.title = item.title
                        ob.link = item.link
                        ob.image = URL(string: item.image ?? "")
                        let url = URL(string: item.requestData!)
                        ob.requestData = URLRequest(url: url!)
                        
                        self.items.append(ob)
                    }
                    print("ii = \(ii.count)")
                    // ここまで
                    
                    // TableViewの場合
                    if "tableView" == userData[userSetting["displaySelect"]!] {
                        self.performSegue(withIdentifier: "toTableList", sender: self)
                        
                    // CollectionViewの場合
                    } else if "collectionView" == userData[userSetting["displaySelect"]!] {
                        self.performSegue(withIdentifier: "toCollectionList", sender: self)
                    }
                } else {
                    // フィード登録に情報無し
                    print("フィード登録に情報無し")
                    alert = UIAlertController(title: "フィード登録に情報がありません", message: "フィード情報を選択してください", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(closeAction)
                    self.present(alert, animated: true)
                }
            } else {
                // フィード情報無し
                alert = UIAlertController(title: "フィード情報がありません", message: "フィード情報を選択してください", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(closeAction)
                self.present(alert, animated: true)
            }
        } else {
            alert = UIAlertController(title: "チェック", message: "ユーザーが存在しません、新規登録してください", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("--start ログイン画面--")
        self.navigationItem.hidesBackButton = true
        
        if (true) {
            UserDefaults.standard.removeObject(forKey: "registData")
            UserDefaults.standard.removeObject(forKey: "feedInfo")
            UserDefaults.standard.removeObject(forKey: "feedInterval")
            UserDefaults.standard.removeObject(forKey: "fontSize")
            
            // Realm DBアドレス
            let url = Realm.Configuration.defaultConfiguration.fileURL!
            // DB削除？
            try! FileManager.default.removeItem(at: url)
        }
        
        // テスト　DB
        realm = try! Realm()
        let it = realm!.objects(ItemDB.self)
        let re = realm!.objects(RealmDB.self)
        print(it.count)
        print(re.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("--purepare--")
        if (segue.identifier == "toTableList") {
            let nextView: ListViewController = (segue.destination as? ListViewController)!
            nextView.userID = userloginField.text!
            nextView.userData = userData
            nextView.items = self.items
            nextView.fontSizeList = self.fontSizeList
        } else if (segue.identifier == "toCollectionList") {
            let nextView: CollectionViewController = (segue.destination as? CollectionViewController)!
            nextView.userID = userloginField.text!
            nextView.userData = userData
            nextView.items = self.items
            nextView.fontSizeList = self.fontSizeList
        } else if (segue.identifier == "toRSSSelect") {
            print("toRSSSelect")
            let nextView: RSSSelectViewController = (segue.destination as? RSSSelectViewController)!
            nextView.userID = userloginField.text!
            nextView.fontSizeList = self.fontSizeList
            print("toRSS end")
        }
    }
}
