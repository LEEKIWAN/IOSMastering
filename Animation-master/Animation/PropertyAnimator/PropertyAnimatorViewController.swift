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

class PropertyAnimatorViewController: UIViewController {
    
    @IBOutlet weak var redView: UIView!
    
    var animator: UIViewPropertyAnimator?
    
    func moveAndResize() {
        let targetFrame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
        redView.frame = targetFrame
    }
    
    @IBAction func reset(_ sender: Any?) {
        redView.backgroundColor = UIColor.red
        redView.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
    }
    
    @IBAction func pause(_ sender: Any) {
        animator?.pauseAnimation()
        print(animator?.fractionComplete) // 실행 비율
    }
    
    @IBAction func animate(_ sender: Any) {
//        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 7, delay: 0, options: [], animations: {
//            self.moveAndResize()
//        }) { (position) in
//            switch position {
//            case .start:
//                print("start")
//            case .end:
//                print("end")
//            case .current:
//                print("current")
//            }
//        }
        
        animator = UIViewPropertyAnimator(duration: 7, curve: .linear) {
            self.moveAndResize()
        }
        
        animator?.addCompletion({ (position) in
            print("DONE \(position)")
        })
    }
    
    @IBAction func resume(_ sender: Any) {
        animator?.startAnimation()
    }
    
    @IBAction func stop(_ sender: Any) {
        animator?.stopAnimation(false)
        animator?.finishAnimation(at: .current)
    }
    
    @IBAction func add(_ sender: Any) {
        // 액티브나 인엑티브 상태에서만 호출해야한다.
        animator?.addAnimations({
             self.redView.backgroundColor = .blue
        }, delayFactor: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
