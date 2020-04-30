//
//  MyViewController.swift
//  VC
//
//  Created by kiwan on 2020/03/20.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func fromCode(_ sender: UIButton) {
        
//        let vc = UIViewController()
//        vc.view.backgroundColor = UIColor.red
        
        let vc = CustomNibViewController(nibName: "CustomNibViewController", bundle: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
