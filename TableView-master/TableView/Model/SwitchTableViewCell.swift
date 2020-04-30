//
//  SwitchTableViewCell.swift
//  TableView
//
//  Created by kiwan on 2020/03/23.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let v = UISwitch(frame: .zero)
        accessoryView = v
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
