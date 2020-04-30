//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
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

struct Development: Codable {
    let language: String
    let os: String
}


class PropertyListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loadFromBundle(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "plist") else {
            return
        }
        
        if #available(iOS 11.0, *) {
            if let dict = try? NSDictionary(contentsOf: url, error: ()) {
                print(dict)
            }
        } else {
            if let dict = NSDictionary(contentsOf: url) {
                print(dict)
            }
        }
    }
    
    let fileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("data").appendingPathExtension("plist")
    }()
    
    @IBAction func loadFromDocuments(_ sender: Any) {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = PropertyListDecoder()
            
//            let dict = try decoder.decode([String: String].self, from: data)
            let dict = try decoder.decode(Development.self, from: data)
            
            print(dict)
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func saveToDocuments(_ sender: Any) {
        do {
//            let dict = ["language": "Swift", "os": "IOS"]
            let dev = Development(language: "Objective-C", os: "ios")
            
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(dev)
            
            try data.write(to: fileURL)
            
            print("done")
        }
        catch {
            print(error)
        }
    }
}
