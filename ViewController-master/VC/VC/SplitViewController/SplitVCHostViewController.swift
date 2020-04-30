//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class SplitVCHostViewController: UIViewController {
    @IBAction func presentSplitViewController(_ sender: Any) {
        guard let masterVC = storyboard?.instantiateViewController(withIdentifier: "ColorListTableViewController") else {
            return
        }
        
        let nav = UINavigationController(rootViewController: masterVC)
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "ColorDetailViewController") else {
            return
        }
        
        let splitVC = CustomSplitViewController()
        splitVC.viewControllers = [nav, detailVC]
        
        splitVC.presentsWithGesture = false
        
        splitVC.preferredPrimaryColumnWidthFraction = 0.5
        splitVC.minimumPrimaryColumnWidth = 100
        splitVC.maximumPrimaryColumnWidth = self.view.bounds.size.width / 2
        
        if #available(iOS 11.0, *) {
            splitVC.primaryEdge = .trailing
        } else {
            // Fallback on earlier versions
        }
        
        
        present(splitVC, animated: true, completion: nil)
    }
    
    @IBAction func unwindToSplitHost(_ sender: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CustomSplitViewController {
            vc.setupDefaultValue()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}





























