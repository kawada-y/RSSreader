//
//  ChangeFontViewController.swift
//  RSSreader
//
//  Created by kawada-y on 2020/07/07.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

class ChangeFontViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    @IBOutlet weak var listFontPicker: UIPickerView!
    @IBOutlet weak var otherFontPicker: UIPickerView!
    
    var userID: String!
    var fontSizeList: [Int]!
    
    fileprivate var settings: UserDefaults!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          fontSizeTitles.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return fontSizeTitles[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            if pickerView == listFontPicker {
                pickerLabel?.font = UIFont.systemFont(ofSize: CGFloat(Int(fontSizeTitles[self.fontSizeList[0]])!))
                pickerLabel?.text = fontSizeTitles[row]
            } else if pickerView == otherFontPicker {
                pickerLabel?.font = UIFont.systemFont(ofSize: CGFloat(Int(fontSizeTitles[self.fontSizeList[1]])!))
                pickerLabel?.text = fontSizeTitles[row]
            }
            pickerLabel?.textAlignment = .center
        }
       
        return pickerLabel!
    }
    
    // 選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == listFontPicker {
            print("記事一覧表示")
            self.fontSizeList[0] = row
            
            listFontPicker.reloadAllComponents()
        } else if pickerView == otherFontPicker {
            print("その他表示")
            self.fontSizeList[1] = row
            
            Utility.changeFont(view: self, fontSize: self.fontSizeList[1])
            otherFontPicker.reloadAllComponents()
        }
        
        let registrationFontSize: [String: [Int]] = [self.userID: self.fontSizeList]
        
        let settings = UserDefaults.standard
        if var registeredFontSize = settings.dictionary(forKey: "fontSize") {
            if var userFontSizeDate = registeredFontSize[self.userID] as? [Int] {
                userFontSizeDate = self.fontSizeList
                registeredFontSize[self.userID] = userFontSizeDate
                settings.set(registeredFontSize, forKey: "fontSize")
            } else {
                settings.set(registeredFontSize.union(registrationFontSize), forKey: "fontSize")
            }
        } else {
            settings.set(registrationFontSize, forKey: "fontSize")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listFontPicker.delegate = self
        listFontPicker.dataSource = self
        otherFontPicker.delegate = self
        otherFontPicker.dataSource = self
        
        listFontPicker.selectRow(self.fontSizeList[0], inComponent: 0, animated: false)
        otherFontPicker.selectRow(self.fontSizeList[1], inComponent: 0, animated: false)
        
        Utility.setFont(view: self, fontSize: self.fontSizeList[1])
    }
}
