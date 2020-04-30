//
//  NotificationViewController.swift
//  PushContentExtension
//
//  Created by kiwan on 2020/03/13.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        preferredContentSize = CGSize(width: view.bounds.width, height: 200)
    }
    
    func didReceive(_ notification: UNNotification) {
        titleLabel.text = notification.request.content.title
        bodyLabel.text = notification.request.content.body
        
        guard let imageAttachment = notification.request.content.attachments.first else {
            return
        }
        
        if imageAttachment.url.startAccessingSecurityScopedResource() {
            if let imageData = try? Data(contentsOf: imageAttachment.url) {
                imageView.image = UIImage(data: imageData)
            }
            
            imageAttachment.url.stopAccessingSecurityScopedResource()
        }
    }

    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        let title = response.notification.request.content.title
        
        switch response.actionIdentifier {
        case "ACTION_LIKE":
            titleLabel.text = "\(title) UP"
        case "ACTION_DISLIKE":
            titleLabel.text = "\(title) DOWN"
        default:
            break
        }
        
        completion(.doNotDismiss)
    }
}
