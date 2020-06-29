//
//  LoginViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // ユーザー事に登録されている内容
    let userSetting: [String:Int] = ["password": 0,
                                     "feedTitle": 1,
                                     "feedAddress": 2,
                                     "displaySelect": 3
    ]
    // ユーザー情報
    var userData: [String]!
    // 選択フィード情報
    var items = [Item]()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
            
            if usernameField.text!.isEmpty {
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
            
            guard let registeredUserdata = registeredData[usernameField.text!] else {
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
                if let feedInfo = registeredFeedInfo[usernameField.text!] as? Data {
                    // フィード登録に情報有り
                    self.items = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(feedInfo) as! [Item]
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
        
        //UserDefaults.standard.removeObject(forKey: "registData")
        //UserDefaults.standard.removeObject(forKey: "feedInfo")
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
            nextView.userID = usernameField.text!
            nextView.userData = userData
            nextView.items = self.items
        } else if (segue.identifier == "toCollectionList") {
            let nextView: CollectionViewController = (segue.destination as? CollectionViewController)!
            nextView.userID = usernameField.text!
            nextView.userData = userData
            nextView.items = self.items
        } else if (segue.identifier == "toRSSSelect") {
            print("toRSSSelect")
            let nextView: RSSSelectViewController = (segue.destination as? RSSSelectViewController)!
            nextView.userID = usernameField.text!
            print("toRSS end")
        }
    }
}
