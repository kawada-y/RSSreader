//
//  Refresh.swift
//  RSSreader
//
//  Created by kawada-y on 2020/07/06.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import Foundation

@objc public protocol RefreshP {
    var userID: String! {get set}
    
    func refreshAction()
    @objc func updateRefresh()
}
