//
//  CommentTableViewCell.swift
//  TableView
//
//  Created by kiwan on 2020/03/27.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
   
    var comment: Comment? {
        didSet {
            if let comment = comment {
                commentLabel.text = comment.text
            }
            else {
                commentLabel.text = nil
            }
        }
    }
}
