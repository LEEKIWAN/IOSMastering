//
//  FooterCollectionReusableView.swift
//  CollectionView
//
//  Created by kiwan on 2020/03/09.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
    
    var sectionFooterLabel: UILabel!
    
    private func setup() {
        let label = UILabel(frame: bounds)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        
        addSubview(label)
        
        if #available(iOS 11.0, *) {
            label.leadingAnchor.constraintEqualToSystemSpacingAfter(leadingAnchor, multiplier: 1.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        sectionFooterLabel = label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
