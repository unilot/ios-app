//
//  NotificationService.swift
//  UnilotNotifications
//
//  Created by Alyona on 11/18/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        let notif_info = bestAttemptContent?.userInfo as? [String: Any]

        let line_save = parseNotif(notif_info)

        
        if line_save != nil {
            
            let defaultsGroup = UserDefaults.init(suiteName: "group.unilot")
            var notifications  = defaultsGroup?.value(forKey: "notifications") as? [String]
            
            if notifications == nil {
                notifications = [String]()
            }
            
            if !notifications!.contains(line_save!) {
                notifications!.append(line_save!)
            }
            
            defaultsGroup?.set(notifications, forKey: "notifications")
            
            bestAttemptContent?.badge = NSNumber(value: notifications!.count)

        } else {
          
            bestAttemptContent?.badge  = NSNumber(value: 0)
        
        }

        
        contentHandler(bestAttemptContent!)

    }

    
    func parseNotif(_ data : [String : Any]?) -> String? {
        
        
        if let game = data?["data"] as? [String : Any] {

            let action = data?["action"] as? String ?? ""
            
            if action == "game_finished" {
                
                let game_id  = "\(game["id"] ?? "" )"
                
                let type     = game["type"] as? Int ?? 0
                
                return  "\(action)&\(game_id)&\(type)"
                
            }
            
        
        }
        
        return nil
        
    }
    
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
