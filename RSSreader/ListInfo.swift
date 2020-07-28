//
//  ListInfo.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/24.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit
import Reachability
import RealmSwift

class ListInfo: ViewController, XMLParserDelegate {
    
    final class Network {
        static func isOnline() -> Bool {
            guard let reach = try? Reachability() else { return false }
            return reach.connection != .unavailable
        }
    }
    
    
    
    var parser: XMLParser!
    var items = [Item]()
    var item: Item?
    var currentString = ""
    
    var realmDB: RealmDB?
    var itemDB: ItemDB?
    
    var userID = ""
    var checkChange: Bool!
    
    func startDownload(_ selectfeed: String, userID: String, checkChange: Bool, view: UIViewController?) -> Bool {
        print("startDownload")
        print(selectfeed)
        
        self.userID = userID
        self.checkChange = checkChange
        
        if Network.isOnline() {
            // オンライン時
            self.items = []
            realmDB = RealmDB()
            if let url = URL(string: selectfeed) {
                if let parser = XMLParser(contentsOf: url) {
                    self.parser = parser
                    self.parser.delegate = self
                    guard self.parser.parse() else {
                        let okButton = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default)
                        let alert = UIAlertController(title: "フィード情報が正しくありません", message: "フィード情報が選択してください", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(okButton)
                        if view != nil {
                            view!.present(alert, animated: true)
                        }
                        return false
                    }
                }
            }
            return true
        } else {
            // オフライン時
            let okButton = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default)
            let alert = UIAlertController(title: "ネットワークに接続されていません", message: "ネットワークに接続されている状態で選択してください", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(okButton)
            if view != nil {
                view!.present(alert, animated: true)
            }
            return false
        }
    }
    
    func setDelegate(_ controller: UIViewController) {
        self.parser.delegate = controller as? XMLParserDelegate
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {
        self.currentString = ""
        if elementName == "item" {
            self.item = Item()
            self.itemDB = ItemDB()                                      //
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString += string
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        switch elementName {
        case "title": self.item?.title = currentString
            self.itemDB?.title = currentString                          // title
        case "link": self.item?.link = currentString
            self.itemDB?.link = currentString                               // link
            if let url = URL(string: currentString) {
                self.item?.requestData = URLRequest(url: url)
                self.itemDB?.requestData = currentString                // requestData
            }
        case "item": self.items.append(self.item!)
            realmDB?.items.append(self.itemDB!)
        
            let realm = try! Realm()
            
            if (checkChange) {
                print(userID)
                var userDB = realm.objects(RealmDB.self).filter("userID == '\(self.userID)'")
                //var userItemDB = realm.objects(ItemDB.self)
                try! realm.write {
                    realm.add(self.itemDB!)
                    userDB[0].items.append(self.itemDB!)
                }
            } else {
               try! realm.write {
                    realm.add(self.itemDB!)
                }
            }
        case "content:encoded":
            guard let range = currentString.range(of: "<img src=") else { return }
            let start = currentString.index(range.lowerBound, offsetBy: 10)
            guard let range2 = currentString.range(of: "\"", range: start..<currentString.endIndex) else { return }
            let end = range2.lowerBound
            let imageURL = String(currentString[start..<end])
            self.item?.image = URL(string: imageURL)
            self.itemDB?.image = imageURL                                // image
        default: break
        }
        //print(elementName)
        //print(currentString)
    }
}
