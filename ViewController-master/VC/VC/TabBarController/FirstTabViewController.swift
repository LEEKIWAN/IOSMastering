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

class FirstTabViewController: UIViewController {
    
    @IBAction func selectSecondTab(_ sender: Any) {
        guard let secondChild = tabBarController?.viewControllers?[1] else {
            return
        }
        
        tabBarController?.selectedViewController = secondChild
    }
    
    @IBAction func selectThirdTab(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    
    override func awakeFromNib() {
//        tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        
        let regularImage = UIImage(named: "calendar_regular")
        let compactImage = UIImage(named: "calendar_compact")
        
        let item = UITabBarItem(title: "Calendar", image: regularImage, selectedImage: compactImage)
        item.badgeValue = "7"
        item.badgeColor = .black
//        item.setBadgeTextAttributes(<#T##textAttributes: [String : Any]?##[String : Any]?#>, for: <#T##UIControlState#>)
        
        tabBarItem = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.title = "First"
        tabBarItem.badgeValue = "HOT"
     

    }
}


