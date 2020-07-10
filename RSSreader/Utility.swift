//
//  Utility.swift
//  RSSreader
//
//  Created by kawada-y on 2020/07/07.
//  Copyright © 2020 kawada-y. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    static let fontSizeList = [15,
                               16,
                               17,
                               18,
                               20,
                               22,
                               24,
                               26,
                               28,
                               30
    ]
    
    static func setFont(view: UIViewController, fontSize: Int) {
        changeFont(view: view, fontSize: fontSize)
    }
    
    static func changeFont(view: UIViewController, fontSize: Int) {
        for i in view.view.subviews {
            if let i = i as? UILabel {
                i.font = UIFont.systemFont(ofSize: CGFloat(fontSizeList[fontSize]))
            } else if let i = i as? UITextField {
                i.font = UIFont.systemFont(ofSize: CGFloat(fontSizeList[fontSize]))
            } else if let i = i as? UIButton {
                i.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSizeList[fontSize]))
            }
        }
    }
    
    static func setTableViewCellFont(cell: UITableViewCell, fontSize: Int) {
        cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSizeList[fontSize]))
    }
    
    static func setCollectionViewCellFont(cell: UILabel, fontSize: Int) {
        cell.font = UIFont.systemFont(ofSize: CGFloat(fontSizeList[fontSize]))
    }
}
