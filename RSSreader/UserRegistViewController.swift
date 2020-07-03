//
//  UserRegistViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

extension Dictionary {
    func union(_ other: Dictionary) -> Dictionary {
        var tmp = self
        other.forEach { tmp[$0.0] = $0.1 }
        return tmp
    }
}

class UserRegistViewController: UIViewController {
    
    @IBOutlet weak var registID: UITextField!
    @IBOutlet weak var registPass: UITextField!
    
    // 登録ボタン
    @IBAction func registAction(_ sender: UIButton) {
        let alert: UIAlertController
        let okAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default)
        
        // ユーザーIDチェック
        /* やりたい事
        //
        */
        if registID.text!.isEmpty {
            alert = UIAlertController(title: "チェック", message: "ユーザーIDが未入力です", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            return 
        }
        
        // パスワードチェック
        /* やりたい事
        //
        */
        if registPass.text!.isEmpty {
            alert = UIAlertController(title: "チェック", message: "パスワードが未入力です", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            return
        }
        
        // 登録するデータ
        let registrationData: [String:[String]] = [registID.text! : [registPass.text!, "", "", ""]]
        
        let settings = UserDefaults.standard
        if let registeredData = settings.dictionary(forKey: "registData") {
            // ユーザーID重複チェック
            if registeredData[registID.text!] != nil {
                // ID重複
                alert = UIAlertController(title: "重複チェック", message: "すでに同じユーザーIDが登録されています、ユーザーIDを変更してください", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(okAction)
                self.present(alert, animated: true)
                return
            } else {
                // ID非重複
                settings.set(registeredData.union(registrationData), forKey: "registData")
                print(registeredData.union(registrationData))
            }
        } else {
            settings.set(registrationData, forKey: "registData")
        }
        
        self.performSegue(withIdentifier: "toRSSSelect", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("--登録画面--")
        
        // test
        let c = (self.navigationController?.viewControllers.count)! - 1
        print(c)
        let v = self.navigationController?.viewControllers[1]
        print(v!)
        if type(of: v!) == UserRegistViewController.self {
            print("一致")
        }
        print(type(of: v!) == UserRegistViewController.self)
        print(UserRegistViewController.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toRSSSelect") {
            let nextView: RSSSelectViewController = (segue.destination as? RSSSelectViewController)!
            nextView.userID = registID.text!
        }
    }
}
