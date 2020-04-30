//
//  CustomHeaderView.swift
//  TableView
//
//  Created by kiwan on 2020/03/24.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        countLabel.layer.cornerRadius = countLabel.bounds.height / 2
        countLabel.text = "0"
    }

}
