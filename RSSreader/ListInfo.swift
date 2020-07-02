//
//  ListInfo.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/24.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit
import Reachability


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
    
    func startDownload(_ selectfeed: String, view: UIViewController?) -> Bool {
        print("startDownload")
        print(selectfeed)
        
        if Network.isOnline() {
            // オンライン時
            self.items = []
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
        case "link": self.item?.link = currentString
            if let url = URL(string: currentString) {
                item?.requestData = URLRequest(url: url)
            }
        case "item": self.items.append(self.item!)
        case "content:encoded":
            guard let range = currentString.range(of: "<img src=") else { return }
            let start = currentString.index(range.lowerBound, offsetBy: 10)
            guard let range2 = currentString.range(of: "\"", range: start..<currentString.endIndex) else { return }
            let end = range2.lowerBound
            let imageURL = String(currentString[start..<end])
            self.item?.image = URL(string: imageURL)
        default: break
        }
    }
}
