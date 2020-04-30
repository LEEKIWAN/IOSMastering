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
import Firebase

struct ActionIdentifier {
    static let like = "ACTION_LIKE"
    static let dislike = "ACTION_DISLIKE"
    static let unfollow = "ACTION_UNFOLLOW"
    static let setting = "ACTION_SETTING"
    private init() {}
}

struct CategoryIdentifier {
    static let imagePosting = "CATEOGRY_IMAGE_POSTING"
    static let categoryCustomUI = "CATEOGRY_CUSTOM_UI"
    private init() {}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let payload = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
            
        }
        
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if granted && error == nil{
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            }
//            self.remotePushSetupCategory()
            self.setupCategory()
            print("granted \(granted)")
        }
        
        FirebaseApp.configure()
        
        return true
    }
    
    func setupCategory() {
        let likeAction = UNNotificationAction(identifier: ActionIdentifier.like, title: "좋아요", options: [])
        let disLikeAction = UNNotificationAction(identifier: ActionIdentifier.dislike, title: "싫어용", options: [])
        let unfollowAction = UNNotificationAction(identifier: ActionIdentifier.unfollow, title: "언팔", options: [.authenticationRequired, .destructive])
        let settingAction = UNNotificationAction(identifier: ActionIdentifier.setting, title: "셋팅", options: [.foreground])
        
        var options = UNNotificationCategoryOptions.customDismissAction
        
        if #available(iOS 11.0, *) {
            options.insert(.hiddenPreviewsShowTitle)
        }
        
        let imagePostingCategory = UNNotificationCategory(identifier: CategoryIdentifier.imagePosting, actions: [likeAction, disLikeAction, unfollowAction, settingAction], intentIdentifiers: [], options: options)
        
        
        let customUICategory = UNNotificationCategory(identifier: CategoryIdentifier.categoryCustomUI, actions: [likeAction, disLikeAction], intentIdentifiers: [], options: [])
        
        
        if UNUserNotificationCenter.current().supportsContentExtensions {
            UNUserNotificationCenter.current().setNotificationCategories([imagePostingCategory, customUICategory])
        }
        else {
            UNUserNotificationCenter.current().setNotificationCategories([imagePostingCategory])
        }
    }
    
    func remotePushSetupCategory() {
        let confirmAction = UNNotificationAction(identifier: "ACTION_CONFIRM", title: "화킨", options: [])
        let deleteAction = UNNotificationAction(identifier: "ACTION_DELETE", title: "삭제", options: [])
        
        let friendRequestCategory = UNNotificationCategory(identifier: "CATEGORY_FRIEND_REQUEST", actions: [confirmAction, deleteAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([friendRequestCategory])
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 포어 그라운드일경우 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let aps = notification.request.content.userInfo["aps"] as? [AnyHashable: Any], let _ = aps["content-available"] {
            completionHandler([])
            return
        }
        
        print("#2 : ", #function, notification.request.content.userInfo)
        
        
        let content = notification.request.content
        let trigger = notification.request.trigger
        
        print(notification.request.content.userInfo)
        
        if let data = notification.request.content.userInfo["data"] as? String {
            UserDefaults.standard.set(data, forKey: "data")
            UserDefaults.standard.synchronize()
        }
        
        NotificationCenter.default.post(name: .DataDidReceive, object: nil)
        
        completionHandler([.alert])
    }
    
    // 상단 푸쉬 알람 눌렀을경우 호출 or 카테고리 눌렀을경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("#3 : ", #function, response.notification.request.content.userInfo)
        
        let content = response.notification.request.content
        let trigger = response.notification.request.trigger
        
        switch response.actionIdentifier {
        case ActionIdentifier.like:
            print("Like")
        case ActionIdentifier.dislike:
            print("DisLike")
        case UNNotificationDismissActionIdentifier:
            print("Custom Dismiss")
        case UNNotificationDefaultActionIdentifier:
            print("Launced From notification")
        default:
            print("Defaults")
        }
        
        UserDefaults.standard.set(response.actionIdentifier, forKey: "userSel")
        UserDefaults.standard.synchronize()
        
        
        //
        
        if let data = response.notification.request.content.userInfo["data"] as? String {
            UserDefaults.standard.set(data, forKey: "data")
            UserDefaults.standard.synchronize()
        }
        
        NotificationCenter.default.post(name: .DataDidReceive, object: nil)
        
        completionHandler()
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // Silent Push
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("#1 : ", #function, userInfo)
        
        if let data = userInfo["data"] as? String {
            UserDefaults.standard.set(data, forKey: "data")
            UserDefaults.standard.synchronize()
        }
        
        if application.applicationState == .active {
            NotificationCenter.default.post(name: .DataDidReceive, object: nil, userInfo: nil)
        }
        
        completionHandler(.newData)
    }
}
