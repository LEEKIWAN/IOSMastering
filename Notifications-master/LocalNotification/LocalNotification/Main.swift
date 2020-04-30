//
//  Main.swift
//  LocalNotification
//
//  Created by kiwan on 2020/03/11.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let DataDidReceive = NSNotification.Name("DataDidreceivceNotification")
}

class Main: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: .DataDidReceive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: .UIApplicationWillEnterForeground, object: nil)
    }

    @objc func updateLabel() {
        DispatchQueue.main.async {
            self.navigationItem.title = UserDefaults.standard.string(forKey: "data")
        }
    }

    
    
}
