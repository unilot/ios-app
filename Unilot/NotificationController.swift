//
//  NotificationController.swift
//  Unilot
//
//  Created by Alyona on 10/30/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications



class UserNotifications {
      
    
    static func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                // actions based on whether notifications were authorized or not
            }
            application.registerForRemoteNotifications()
            
        } else {
            
            // Fallback on earlier versions
            
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
            perform(#selector(UserNotifications.startAfterAnswerFromRemoteNotifications), with: nil, afterDelay: 5)
            
        }
    }
    
    
    static func startAfterAnswerFromRemoteNotifications(){
        if  !startWas {
            startWas = true
            NotificationCenter.default.post(name: Notification.Name(rawValue: "enter_after_start"), object: nil)
        }
    }
    
    
    //MARK: -
    
    
    static func parseNotification(_ notificationDictionary:[String: Any], isOpened: Bool) {
        
        print(notificationDictionary)
        
        notification_data.append( notificationDictionary )
        
        MemoryControll.saveObject(notification_data, key: "notifications_app")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NOTIFICATION_CAME"), object: nil)
        
    }
    
    
    
    static func cleanNotificationStack(){
        
        notification_data = []
        
        MemoryControll.removeObject("notifications_app")
        
    }
    
    //MARK: - NOTIFICATIO PARSE
    
    static func notificationAction(){
        
        let action = notification_data.first!["action"] as? String
        
        
        if action == nil {
        
             return
        }
        
        switch action! {
            
        //Начало игры:
        case "game_started":
            
            
            break
            
        //Завершение приёма заявок и начало определения победител
        case "game_unpublished":
            
            
            break
            
        //Завершение определения победителей:
        case "game_finished":
            
            
            break
            
        //Отчёт об игре:
        case "game_updated":
            
            
            
            break
            
        default:
            
            break
        }
        
        print(notification_data.first!["data"])
        
    }
    
    
}
