//
//  CollectionViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/19.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit

private let reuseIdentifier = "articleCell2"

class CollectionViewController: UICollectionViewController, XMLParserDelegate {
    
//    var parser: XMLParser!
//    var items = [Item]()
//    var item: Item?
//    var currentString = ""
    
    var userID: String!
    var userData: [String]!
    
    var items: [Item]!
    
    @IBOutlet weak var tableTitle: UINavigationItem!
    
    @IBOutlet var colView: UICollectionView!
    
    // ログイン画面に戻るボタン
    @IBAction func goBackLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    // 設定ボタン
    @IBAction func toSetting(_ sender: Any) {
        self.performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("--記事一覧画面 CollectionView--")
        self.navigationItem.hidesBackButton = true
        
        tableTitle.title = userData[1]
        //startDownload(userData[2])
        
        self.collectionView.reloadData()
    }
    
//    func startDownload(_ selectfeed: String) {
//        print("startDownload")
//        self.items = []
//        if let url = URL(string: selectfeed) {
//            if let parser = XMLParser(contentsOf: url) {
//                self.parser = parser
//                self.parser.delegate = self
//                self.parser.parse()
//            }
//        }
//    }
//
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
//        case "content:encoded":
//            guard let range = currentString.range(of: "<img src=") else { return }
//            let start = currentString.index(range.lowerBound, offsetBy: 10)
//            guard let range2 = currentString.range(of: "\"", range: start..<currentString.endIndex) else { return }
//            let end = range2.lowerBound
//            let imageURL = String(currentString[start..<end])
//            self.item?.image = URL(string: imageURL)
//        default: break
//        }
//    }
//
//    func parserDidEndDocument(_ parser: XMLParser) {
//        self.collectionView.reloadData()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare 遷移前")
        if (segue.identifier == "toArticle") {
            if let indexPath = self.collectionView.indexPathsForSelectedItems {
                let item = items[indexPath[0].row]
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
    
    // セクション単位
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     // 表示アイテム数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // セルの表示
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
       
        // Tag番号を使いインスタンスを作る
        let cellView = cell.contentView.viewWithTag(0)
        
        if items[indexPath.row].image != nil {
            let cellImage = cellView?.viewWithTag(1) as! UIImageView
            if let image = try? Data(contentsOf: items[indexPath.row].image!) {
                cellImage.image = UIImage(data: image)
            }
        }
        
        let cellLabel = cellView?.viewWithTag(2) as! UILabel
        cellLabel.text = items[indexPath.row].title
        
        return cell
    }
    
    // セル選択
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toArticle", sender: nil)
    }
}
