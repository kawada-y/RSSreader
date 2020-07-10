//
//  DisplaySettingViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/23.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

class DisplaySettingViewController: UIViewController {
    
    // ユーザー情報
    var userID: String!
    var userData: [String]!
    var fontSizeList: [Int]!
    
    // ラジオボタンの数
    fileprivate let buttons: Int = 2
    // チェックされているボタン
    fileprivate var checkButtonTag = 0
    
    // 画像
    fileprivate let checkedImage = UIImage(named: "check_on")! as UIImage
    fileprivate let uncheckedImage = UIImage(named: "check_off")! as UIImage
    
    @IBOutlet weak var tableButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    
    // ラジオボタン配置
    func setRadioButton(_ button: UIButton, num: Int, checked: Bool) {
        if checked {
            button.setImage(checkedImage, for: UIControl.State.normal)
        } else {
            button.setImage(uncheckedImage, for: UIControl.State.normal)
        }
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        button.tag = num
        self.view.addSubview(button)
    }
    
    // on画像を off画像へ
    func changeToUnchecked(num: Int) {
        for i in view.subviews {
            if let i = i as? UIButton, i.tag == num {
                if i.titleLabel?.text! != "設定の保存" {
                    i.setImage(uncheckedImage, for: UIControl.State.normal)
                }
            }
        }
    }
    
    // 押したボタンを on画像へ
    @objc func buttonClicked(_ sender: UIButton) {
        changeToUnchecked(num: checkButtonTag)
        let button = sender
        button.setImage(checkedImage, for: UIControl.State.normal)
        checkButtonTag = button.tag
        
        // 設定の保存
        let settings = UserDefaults.standard
        var registeredData = settings.dictionary(forKey: "registData")!
        
        if checkButtonTag == 0 {
            userData[3] = "tableView"
        } else if checkButtonTag == 1 {
            userData[3] = "collectionView"
        }
        registeredData[userID] = userData
        settings.set(registeredData, forKey: "registData")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.setFont(view: self, fontSize: fontSizeList[1])
        
        var checkTable = false
        var checkCollection = false
        print("切替画面　\(userData[3])")
        if userData[3] == "tableView" {
            checkTable = true
            checkCollection = false
            checkButtonTag = 0
        } else if userData[3] == "collectionView" {
            checkTable = false
            checkCollection = true
            checkButtonTag = 1
        }
        
        setRadioButton(tableButton, num: 0, checked: checkTable)
        setRadioButton(collectionButton, num: 1, checked:  checkCollection)
    }
}
