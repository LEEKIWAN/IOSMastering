//
//  DetailHeaderView.swift
//  TableView
//
//  Created by kiwan on 2020/03/27.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
            else {
                imageView.image = nil
            }
        }
    }
}
