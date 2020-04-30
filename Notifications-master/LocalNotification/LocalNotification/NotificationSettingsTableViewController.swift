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
import UserNotifications

class NotificationSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var authorizationStatusLabel: UILabel!
    @IBOutlet weak var alertStyleLabel: UILabel!
    @IBOutlet weak var showPreviewsLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var notificationCenterLabel: UILabel!
    @IBOutlet weak var lockScreenLabel: UILabel!
    
    func update(from settings: UNNotificationSettings) {
        switch settings.authorizationStatus {
        case .notDetermined:
            authorizationStatusLabel.text = "Not Determined"
        case .authorized:
            authorizationStatusLabel.text = "Authorized"
        case .denied:
            authorizationStatusLabel.text = "Denied"
        case .provisional:
            authorizationStatusLabel.text = "Provisional"
        }
        
        switch settings.soundSetting {
        case .enabled:
            soundLabel.text = "Enabled"
        case .disabled:
            soundLabel.text = "Disabled"
        case .notSupported:
            soundLabel.text = "Not Supported"
        }
        
        badgeLabel.text = settings.badgeSetting.stringValue
        
        lockScreenLabel.text = settings.lockScreenSetting.stringValue
        
        notificationCenterLabel.text = settings.notificationCenterSetting.stringValue
        
        alertLabel.text = settings.alertSetting.stringValue
        
        switch settings.alertStyle {
        case .banner:
            alertStyleLabel.text = "Banner"
        case .alert:
            alertStyleLabel.text = "Alert"
        case .none:
            alertStyleLabel.text = "None"
        }
        
        if #available(iOS 11.0, *) {
            switch settings.showPreviewsSetting {
            case .always:
                showPreviewsLabel.text = "Always"
            case .whenAuthenticated:
                showPreviewsLabel.text = "When Authenticated"
            case .never:
                showPreviewsLabel.text = "Never"
            }
        }
        
    }
    
    @objc func refresh() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                self.update(from: settings)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Hello"
            content.body = "Have a nice day :)"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "HelloNoti", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

    }
}

extension UNNotificationSetting {
    var stringValue: String {
        switch self {
        case .notSupported:
            return "Not Supported"
        case .enabled:
            return "Enabled"
        case .disabled:
            return "Disabled"
        }
    }
}


















