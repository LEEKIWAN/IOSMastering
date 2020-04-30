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

class SimpleUIViewAnimationViewController: UIViewController {
    
    @IBOutlet weak var redView: UIView!
    
    @IBAction func reset(_ sender: Any?) {
        redView.backgroundColor = UIColor.red
        redView.alpha = 1.0
        redView.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
    }
    
    @IBAction func Stop(_ sender: Any) {
        redView.layer.removeAllAnimations()
        reset(nil)
    }
    
    
    
    @IBAction func animate(_ sender: Any) {
        let animation: () -> () = {
            var frame = self.redView.frame
            frame.origin = self.view.center
            frame.size = CGSize(width: 100, height: 100)
            self.redView.frame = frame
            self.redView.alpha = 0.5
            self.redView.backgroundColor = UIColor.blue
        }
        
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: animation, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reset(nil)
    }
}





















