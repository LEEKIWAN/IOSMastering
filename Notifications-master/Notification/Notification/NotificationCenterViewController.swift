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

class NotificationCenterViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @objc func process(notification: Notification) {
        print(Thread.isMainThread ? "Main" : "Background")
        
        guard let value = notification.userInfo?["newValue"] as? String else {
            return
        }
        
        DispatchQueue.main.async {
            self.valueLabel.text = value
        }
        
        
        print(#function, "1")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)), name: .NewValueDidInput, object: nil)
        
        NotificationCenter.default.addObserver(forName: .NewValueDidInput, object: nil, queue: .main) { [weak self] (notification) in
            guard let self = self else { return }
            guard let value = notification.userInfo?["newValue"] as? String else {
                return
            }
            
            self.valueLabel.text = value
            
            print(#function, "2")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print(#function)
    }
}
