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

class DispatchWorkItemViewController: UIViewController {
    
    let workQueue = DispatchQueue(label: "WorkQueue")
    var currentWorkItem: DispatchWorkItem!
    
    @IBAction func submitItem(_ sender: Any) {
        currentWorkItem = DispatchWorkItem(block: {
            for num in 0 ..< 100 {
                guard !self.currentWorkItem.isCancelled else { return }
                print(num, separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.1)
            }
        })
        
        workQueue.async(execute: currentWorkItem)
        
        currentWorkItem.notify(queue: workQueue) {
            print("Done")
        }
        
        let result = currentWorkItem.wait(timeout: .now() + 3)
        
        switch result {
        case .timedOut:
            print("timedOut")
        case .success:
            print("success")
        }
        
    }
    
    @IBAction func cancelItem(_ sender: Any) {
        currentWorkItem.cancel()
    }
}