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

class CustomSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        preferredDisplayMode = .automatic
    }
    
    func setupDefaultValue() {
        guard let nav = viewControllers.first as? UINavigationController, let masterVC = nav.viewControllers.first as? ColorListTableViewController else {
            return
        }
        
        guard let detailVC = viewControllers.last?.childViewControllers.first as? ColorDetailViewController else {
            return
        }
        
        detailVC.color = masterVC.list.first
        
        switch displayMode {
        case .primaryHidden, .primaryOverlay:
            detailVC.navigationItem.leftBarButtonItem = displayModeButtonItem
        default:
            detailVC.navigationItem.leftBarButtonItem = nil
        }
    }
}



extension CustomSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        switch displayMode {
        case .primaryHidden, .primaryOverlay:
            viewControllers.last?.childViewControllers.first?.navigationItem.leftBarButtonItem = displayModeButtonItem
        default:
            viewControllers.last?.childViewControllers.first?.navigationItem.leftBarButtonItem = nil
        }
    }
}


