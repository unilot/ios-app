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



class NotifApp {
      
    
    static func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound])
            { (_ granted : Bool , _ error : Error?) in
                // actions based on whether notifications were authorized or not
               
                if granted {
                    application.registerForRemoteNotifications()
                } else {
                     if error != nil {
                        print("error push id " + error!.localizedDescription )
                    }
                }

            }
            
            application.registerForRemoteNotifications()
            application.registerUserNotificationSettings(UIUserNotificationSettings(types:  [.badge, .alert, .sound], categories: nil))
            
        } else {
            
            // Fallback on earlier versions
            
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            application.registerUserNotificationSettings(UIUserNotificationSettings(types:  [.badge, .alert, .sound], categories: nil))

            startAfterAnswerFromRemoteNotifications()
            
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
        
        parseNotificationAction( notificationDictionary )
        
    }
    
    static func cleanLastNotification (){
        
        if notification_data.count > 0 {
            notification_data.removeLast()
        }
        
        MemoryControll.saveObject(notification_data, key: "notifications_app")
        
    }
    
    static func cleanNotificationStack(){
        
        notification_data.removeAll()
        
        MemoryControll.removeObject("notifications_app")
        
    }
    
    //MARK: - LOCAL NOTIFICATIONS
    
    
    //MARK: - NOTIFICATION PARSE
    
    static func parseNotificationAction( _ notificationDictionary : [String : Any] ){

        let action = notification_data.first!["action"] as? String
        let data   = notification_data.first!["data"] as? [String : Any]
        
        
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
            
            if data != nil {
                
                let item = NetWork.createGameItem(from: data!)

                let tababrNumber = tabbar_strings.index(of: item.game_id)!
                let oldItem = games_list[tababrNumber]!
               
                MemoryControll.saveGameMoneyStart( Int(oldItem.prize_amount_fiat) / 1000 , tababrNumber)

                games_list[tababrNumber] = item
   
            }
        
            current_controller_core?.onNotifRecieved()

            
            break
            
        default:
            
            break
        }
        
        notification_data.append( notificationDictionary )
        
        MemoryControll.saveObject(notification_data, key: "notifications_app")

        
    }

    
}
