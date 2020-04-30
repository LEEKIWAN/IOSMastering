//
//  DetailHeaderView2.swift
//  TableView
//
//  Created by 이기완 on 2020/03/29.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class DetailHeaderView2: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed("DetailHeaderView2", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    
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
