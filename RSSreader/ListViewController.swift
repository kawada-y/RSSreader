//
//  ListViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController, XMLParserDelegate {
    
//    var parser: XMLParser!
//    var items = [Item]()
//    var item: Item?
//    var currentString = ""
    
    var userID: String!
    var userData: [String]!
    
    //var feedInfo: ListInfo!
    var items: [Item]!
    
    @IBOutlet weak var tableTitle: UINavigationItem!
    
    // ログイン画面に戻るボタン
    @IBAction func goBackLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    // 設定ボタン
    @IBAction func settingAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("--記事一覧画面 TableView--")
        self.navigationItem.hidesBackButton = true
        
        tableTitle.title = userData[1]
        //feedInfo.startDownload(userData[2])
        
        //feedInfo.setDelegate(self)
        
        self.tableView.reloadData()
    }
    
//    func startDownload(_ selectfeed: String) {
//        self.items = []
//        if let url = URL(string: selectfeed) {
//            if let parser = XMLParser(contentsOf: url) {
//                self.parser = parser
//                self.parser.delegate = self
//                self.parser.parse()
//            }
//        }
//    }
    
//    func parser(_ parser: XMLParser,
//                didStartElement elementName: String,
//                namespaceURI: String?,
//                qualifiedName qName: String?,
//                attributes attributeDict: [String : String]) {
//        self.currentString = ""
//        if elementName == "item" {
//            self.item = Item()
//        }
//    }
//
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        self.currentString += string
//    }
//
//    func parser(_ parser: XMLParser,
//                didEndElement elementName: String,
//                namespaceURI: String?,
//                qualifiedName qName: String?) {
//        switch elementName {
//        case "title": self.item?.title = currentString
//        case "link": self.item?.link = currentString
//        case "item": self.items.append(self.item!)
//        default: break
//        }
//    }
//
//    func parserDidEndDocument(_ parser: XMLParser) {
//        self.tableView.reloadData()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toArticle") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let item = items[indexPath.row]
                let controller = segue.destination as! ArticleViewController
                controller.title = item.title
                //controller.link = item.link
                controller.requestData = item.requestData
            }
        } else if (segue.identifier == "toSetting") {
            let nextView = segue.destination as! ConfigViewController
            nextView.userID = self.userID
        }
    }
}

