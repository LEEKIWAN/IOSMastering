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

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    lazy var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "hh:mm:ss"
        return f
    }()
    
    @IBAction func unwindToTimerHome(_ sender: UIStoryboardSegue) {
        
    }
    
    func updateTimer(_ timer: Timer) {
        print(#function, Date(), timer)
        timeLabel.text = formatter.string(from: Date())
    }
    
    func resetTimer() {
        timeLabel.text = "00:00:00"
    }
    
    var timer: Timer?
    
    @IBAction func startTimer(_ sender: Any) {
        guard timer == nil else { return }
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
//            guard timer.isValid else { return }
//            self.updateTimer(timer)
//        })
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
        timer?.fire()
    }
    
    @objc func timerFired(_ timer: Timer) {
        updateTimer(timer)
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startTimer(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
}
