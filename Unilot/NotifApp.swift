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
import SCLAlertView



class NotifApp {
      
    
    static func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound])
            { (_ granted : Bool , _ error : Error?) in
                // actions based on whether notifications were authorized or not
               
                if granted {

                
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
         
//        SCLAlertView().showTitle("NOTIFICATION", subTitle: notificationDictionary.description, style: .info)
 
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
    
     
    
    //MARK: - NOTIFICATION PARSE
    
    static func parseNotif(_ data : [String : Any]) -> NotifStruct {
        
        let notifItem = NotifStruct()
        
        notifItem.action = data["action"] as? String ?? kActionUndefined
        
        if let dataDict = data["data"] as? [String : Any] {
            
            notifItem.game = NetWork.createGameItem(from: dataDict)
            
            if notifItem.game.game_id == kEmpty {
                notifItem.data = dataDict
            }
        }
        
        return notifItem
        
    }
    
    static func parseNotificationAction( _ notificationDictionary : [String : Any] ){

        let notifItem = parseNotif(notificationDictionary)
        
        switch notifItem.action {
            
        //Начало игры:
        case  kActionStarted:
             
            break
            
        //Завершение приёма заявок и начало определения победител
        case kActionFinishing:
            
            
            
            break
            
        //Завершение определения победителей:
        case kActionCompleted:
 
            notification_data.append( notificationDictionary )
            MemoryControll.saveObject(notification_data, key: "notifications_app")

            break
            
        //Отчёт об игре:
        case kActionUpdate:
            

            
            break
            
        default: // kActionUndefined
            
            
            return
        }
        
         
        if notifItem.game.game_id != kEmpty  {
            
            let game_item = games_list[notifItem.game.type]
            
            if (game_item != nil) && (game_item!.game_id == notifItem.game.game_id) {

                MemoryControll.saveGameMoneyStart ( Int(games_list[local_current_game.type]!.prize_amount) / 1000, notifItem.game)
                games_list[local_current_game.type] = notifItem.game
                local_current_game = notifItem.game
            
            }

        }
 
 
        current_controller_core?.onNotifRecieved(notifItem.action, notifItem.game.type)
        
        
    }

    
    
    
    
    static var numberOfFakeGamers: Int = 5

    static func sendFakeNotif(){
     
        numberOfFakeGamers = numberOfFakeGamers + 1
        
        let fake_data = ["action": kActionCompleted,//kActionFinishing,//kActionUpdate,
                         "data":
        [
            "ending_at" : "2017-11-05T14:00:00Z",
            "id" : 6,
            "num_players" : numberOfFakeGamers,
            "prize_amount" : 0.021,
            "prize_amount_fiat" : 5.978490000000001,
            "smart_contract_id" : "0xb588530e3956d9787b0429244ca360f566ff3301",
            "started_at" : "2017-10-29T15:00:00Z",
            "status" : kStatusComplete,
            "type": kTypeWeek,
            ]
        
        ] as [String : Any]
        parseNotificationAction(fake_data)
        
    }
    
    
}
