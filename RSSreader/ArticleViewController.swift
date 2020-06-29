//
//  ArticleViewController.swift
//  RSSリーダーアプリ
//
//  Created by kawada-y on 2020/06/05.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {
    
    var link: String!
    
    var requestData: URLRequest!

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.load(requestData)
    }
}
