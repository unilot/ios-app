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
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound])
            { (_ granted : Bool , _ error : Error?) in
                // actions based on whether notifications were authorized or not
               
                if granted {
                    application.registerForRemoteNotifications()
                } else {
//                    UserNotifications.startAfterAnswerFromRemoteNotifications()
                    if error != nil {
                        print("error push id " + error!.localizedDescription )
                    }
                }

            }
            
            application.registerForRemoteNotifications()

//            application.registerForRemoteNotifications()
            
        } else {
            
            // Fallback on earlier versions
            
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
            UserNotifications.startAfterAnswerFromRemoteNotifications()
            
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
        
        searchForCurrentViewController()
        
    }
    
    
    static func searchForCurrentViewController( ){
       
        if current_controller_core != nil {
            current_controller_core?.onNotifRecieved()
        } else {
            print("current_controller_core = nil")
        }
        
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

        
    }

    
}
