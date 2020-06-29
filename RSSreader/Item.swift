//
//  Item.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/19.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import Foundation.NSObject

public class Item: NSObject, NSCoding {
    
    var title: String?
    var link: String?
    var image: URL?
    var requestData: URLRequest?
    
    override init(){}
    
    // NSKeyedArchiver に呼び出されるシリアライズ処理
    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(link, forKey: "link")
        coder.encode(image, forKey: "image")
        coder.encode(requestData, forKey: "requestData")
    }
    
    // NSKeyedArchiver に呼び出されるデシリアライズ処理
    public required init?(coder: NSCoder) {
        title = (coder.decodeObject(forKey: "title") as? String) ?? ""
        link = (coder.decodeObject(forKey: "link") as? String) ?? ""
        image = (coder.decodeObject(forKey: "image") as? URL) ?? nil
        requestData = (coder.decodeObject(forKey: "requestData") as! URLRequest)
    }
}
