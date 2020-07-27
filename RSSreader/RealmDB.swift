//
//  RealmDB.swift
//  RSSreader
//
//  Created by kawada-y on 2020/07/22.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDB: Object {
    @objc dynamic var userID: String?
    
    let items = List<ItemDB>()
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}

class ItemDB: Object {
    @objc dynamic var title: String?
    @objc dynamic var link: String?
    @objc dynamic var image: String?
    @objc dynamic var requestData: String?
    
    //@objc dynamic var image: URL?
    //@objc dynamic var requestData: URLRequest?
    
    override static func indexedProperties() -> [String] {
        return ["title"]
    }
}
