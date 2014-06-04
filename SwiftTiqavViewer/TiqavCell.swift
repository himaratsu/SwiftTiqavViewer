//
//  TiqavCell.swift
//  SwiftTiqavViewer
//
//  Created by 平松　亮介 on 2014/06/04.
//  Copyright (c) 2014年 himara2. All rights reserved.
//

import UIKit

class TiqavCell: UITableViewCell {
    @IBOutlet var tiqavImageView : UIImageView
    @IBOutlet var tiqavUrlLabel : UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tiqavUrlLabel.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
    }
}
