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

class Language: NSObject, NSCoding, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        return true
    }
    // decoding
    required init?(coder: NSCoder) {
        guard let name = coder.decodeObject(of: NSString.self, forKey: "name") else {
            return nil
        }
        self.name = name as String
        
        guard let version = coder.decodeObject(of: NSNumber.self, forKey: "version") else {
            return nil
        }
        self.version = version.doubleValue
        
        guard let image = coder.decodeObject(of: UIImage.self, forKey: "logo") else {
            return nil
        }
        
        self.logo = image
    }
    // encoding
    func encode(with coder: NSCoder) {
        coder.encode(name as NSString, forKey: "name")
        coder.encode(version as NSNumber, forKey: "version")
        coder.encode(logo, forKey: "logo")
    }
    
    let name: String
    let version: Double
    let logo: UIImage
    
    init(name: String, version: Double, logo: UIImage) {
        self.name = name
        self.version = version
        self.logo = logo
    }
}


class NSCodingViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    let fileUrl: URL = {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("swift").appendingPathExtension("data")
    }()
    
    
    @IBAction func encodeObject(_ sender: Any) {
        do {
            guard let url = Bundle.main.url(forResource: "swiftlogo", withExtension: "png") else {
                return
            }
            
            let data = try Data(contentsOf: url)
            guard let image = UIImage(data: data) else {
                return
            }
            
            let object = Language(name: "swift", version: 5.0, logo: image)
            
            if #available(iOS 11.0, *) {
                let archivedData = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
                
                try archivedData.write(to: fileUrl)
            } else {
                NSKeyedArchiver.archiveRootObject(object, toFile: fileUrl.path)
            }
            
            
            print("Done")
            
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func decodeObject(_ sender: Any) {
        do {
            
            let data = try Data(contentsOf: fileUrl)
            
            var language: Language?
            
            if #available(iOS 11.0, *) {
                try language = NSKeyedUnarchiver.unarchivedObject(ofClass: Language.self, from: data)
            }
            else {
                language = NSKeyedUnarchiver.unarchiveObject(with: data) as? Language
            }
            
            
            if let language = language {
                self.imageView.image = language.logo
                self.nameLabel.text = language.name
                self.versionLabel.text = "\(language.version)"
            }
        }
        catch {
            print(error)
        }
    }
}
