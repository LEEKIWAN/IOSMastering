//
//  ColorCollectionViewCell.swift
//  CollectionView
//
//  Created by 이기완 on 2020/03/07.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        colorView.layer.cornerRadius = colorView.frame.size.height / 2
    }
}
