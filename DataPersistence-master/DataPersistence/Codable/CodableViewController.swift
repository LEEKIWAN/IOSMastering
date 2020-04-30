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

struct CodableLanguage: Codable {
    let name: String
    let version: Double
    let logo: Data
}


class CodableViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    let fileUrl: URL = {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("ios").appendingPathExtension("data")
    }()
    
    @IBAction func encodeObject(_ sender: Any) {
        do {
            guard let url = Bundle.main.url(forResource: "ioslogo", withExtension: "png") else {
                return
            }
            
            let data = try Data(contentsOf: url)
            
            let obj = CodableLanguage(name: "iOS", version: 12.0, logo: data)
            
            let archiver: NSKeyedArchiver
            
            if #available(iOS 11.0, *) {
                archiver = NSKeyedArchiver(requiringSecureCoding: true)
            }
            else {
                archiver = NSKeyedArchiver()
            }
            
            try archiver.encodeEncodable(obj, forKey: NSKeyedArchiveRootObjectKey)
            try archiver.encodedData.write(to: fileUrl)
            
            archiver.finishEncoding()
            
            print("Done")
            
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func decodeObject(_ sender: Any) {
        do {
            let data = try Data(contentsOf: fileUrl)
            
            var language: CodableLanguage?
            
            let unarchiver: NSKeyedUnarchiver
            
            if #available(iOS 11.0, *) {
                unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            }
            else {
                unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            }

            
            language = unarchiver.decodeDecodable(CodableLanguage.self, forKey: NSKeyedArchiveRootObjectKey)
            
            unarchiver.finishDecoding()
            
            if let language = language {
                self.imageView.image = UIImage(data: language.logo)
                self.nameLabel.text = language.name
                self.versionLabel.text = "\(language.version)"
            }
        } catch {
            print(error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
