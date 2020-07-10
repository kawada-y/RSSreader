//
//  RSSIntervalViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/26.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

class RSSIntervalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    fileprivate let fontSizeTitles: [String] = ["15",
                                                "16",
                                                "17",
                                                "18",
                                                "20",
                                                "22",
                                                "24",
                                                "26",
                                                "28",
                                                "30"
    ]
    
    // ユーザー情報
    var userID: String!
    var userData: [String]!
    var fontSizeList: [Int]!
    
    fileprivate let settingTitles = ["自動更新無し",
                                     "３日",
                                     "１日",
                                     "12時間",
                                     "6時間",
                                     "3時間",
                                     "1時間",
                                     "テスト2分",
                                     "テスト1分"
    ]
    
    fileprivate let settingInterval: [Double] = [0,
                                     259200,
                                     86400,
                                     43200,
                                     21600,
                                     10800,
                                     3600,
                                     120,
                                     60
    ]
    
    fileprivate var selectIntervalNumber: Int!
    
    @IBOutlet weak var intervalPicker: UIPickerView!
    
    // 決定ボタン
    @IBAction func decisionAction(_ sender: Any) {
        let settings = UserDefaults.standard
        
        // 登録するフィード取得間隔情報
        let registrationFeedInterval: [String:Int] = [self.userID: selectIntervalNumber]
        // 登録ユーザーフィード取得間隔情報
        var registeredFeedInterval = settings.dictionary(forKey: "feedInterval")
        
        if 0 < selectIntervalNumber {
            FeedUpdate.intervalUpdate(userID: self.userID, feedAddress: self.userData[2], timeInterval: settingInterval[selectIntervalNumber], repeats: true)
            var userInterval = registeredFeedInterval![userID] as! Int
            userInterval = selectIntervalNumber
            registeredFeedInterval![userID] = userInterval
            settings.set(registrationFeedInterval, forKey: "feedInterval")
        } else {
            FeedUpdate.invalidateUpdate()
        }
    }
    
    // 一覧を更新するボタン
//    @IBAction func updateAction(_ sender: Any) {
//        let settings = UserDefaults.standard
//        let okButton = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default)
//
//        let feedInfo = ListInfo()
//        if feedInfo.startDownload(self.userData[2], view: self) {
//            // フィード接続　OK
//            let items = feedInfo.items
//            let feedData = try! NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
//
//            // 登録ユーザーフィード情報
//            var registeredFeedInfo = settings.dictionary(forKey: "feedInfo")
//            var userFeedInfo = registeredFeedInfo![userID]
//            userFeedInfo = feedData
//            registeredFeedInfo![userID] = userFeedInfo
//            // 登録ユーザーフィード情報の更新
//            settings.set(registeredFeedInfo, forKey: "feedInfo")
//
//            let alert = UIAlertController(title: "情報", message: "一覧が更新されました", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(okButton)
//            self.present(alert, animated: true)
//        } else {
//            // フィード接続　NG
//            return
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intervalPicker.delegate = self
        intervalPicker.dataSource = self
        
        //intervalPicker.
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settingTitles.count
    }
    
    // pickerView のタイトル
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
//        return settingTitles[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: CGFloat(Int(fontSizeTitles[fontSizeList[1]])!))
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = settingTitles[row]
        return pickerLabel!
    }
    
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        var attributedString: NSMutableAttributedString
//        let myAttribute = [NSAttributedString: UIFont.systemFont(ofSize: CGFloat(30))]
//        attributedString = NSMutableAttributedString(string: settingTitles[row], attributes: myAttribute)
//        return attributedString
//    }
    
    // 選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectIntervalNumber = row
    }
}
