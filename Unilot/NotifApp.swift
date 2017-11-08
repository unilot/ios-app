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
import LocalNotificationHelper



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
    
    static func parseNotification(_ notificationDictionary:[String: Any],_  gameStatus: UIApplicationState) {
        
        playStandart()
        print(notificationDictionary)
         
//        SCLAlertView().showTitle("NOTIFICATION", subTitle: notificationDictionary.description, style: .info)
 
        parseNotificationAction( notificationDictionary, gameStatus   )
        
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
    
    
    
    //MARK: - SOME SMALL STUFF
    
    static func getDataFromNotifString(_ idOfData : Int) -> String? {
        
        if open_from_notif != nil {
            return open_from_notif!.components(separatedBy: "&")[idOfData]
        }

        return nil
    }
    
    
    static func getElementFromNotif(_ notif_id : String) ->  [String : Any]? {
        
        let notif = notification_data.filter({
            let item = NotifApp.parseNotif($0)
            return item.notif_id == notif_id
        }).first
        
        return notif
    }
    
    
    static func saveNewNotifWithoutElement(_ item : [String : Any] ){
      
        let compere_item = NotifApp.parseNotif(item)
        
        let new_array = notification_data.filter({
            let item = NotifApp.parseNotif($0)
            return item.notif_id != compere_item.notif_id
        })
        
        notification_data = new_array
        MemoryControll.saveObject(new_array, key: "notifications_app")
        
    }
    
    
    //MARK: - NOTIFICATION PARSE

    
    static func parseNotif(_ data : [String : Any]) -> NotifStruct {
        
        let notifItem = NotifStruct()
        
        notifItem.messages = data["message"] as? [String] ?? []
        notifItem.action = data["action"] as? String ?? kActionUndefined
        
        if let dataDict = data["data"] as? [String : Any] {
            
            notifItem.game = NetWork.createGameItem(from: dataDict)
            
            
            if notifItem.game.game_id == kEmpty {
                notifItem.data = dataDict
            } else {
                notifItem.notif_id = "\(notifItem.action)&\(notifItem.game.game_id)&\(notifItem.game.type)"
            }
        }
        
        return notifItem
        
    }
    
    static func parseNotificationAction( _ notificationDictionary : [String : Any], _ gameStatus : UIApplicationState ){
        
        if gameStatus != .active {
            
            MemoryControll.init_defaults_if_any()
        }
        
        
        // parse data from remote notification
        let notifItem = parseNotif(notificationDictionary)
        

        
        // if we have complete game status - save it and change Badge item
        if  notifItem.action == kActionCompleted{
            
            MemoryControll.saveNewNotif(notificationDictionary)
            
            UIApplication.shared.applicationIconBadgeNumber = notification_data.count

        }
        
        // do something with these data if app is closed
        if gameStatus != .active {
            
            // if game id is in notification
            if notifItem.game.game_id != kEmpty {
                
                //  check for users settings of switching of notification
                if notifications_switch[getTabBarTag(notifItem.game.type)] {

                    // send notification from closed app
                    
                    sendNotification(notifItem.messages[current_language_ind], notifItem.notif_id)
                    
                 }
                
            }
            
            

        } else {

            // if game id is in notification
            if notifItem.game.game_id != kEmpty {
                
                games_list[notifItem.game.type] = notifItem.game

            }
            
            
            open_from_notif = notifItem.notif_id

            // do something with these data if app was launched
            current_controller_core?.onNotifRecieved(notifItem)

        }

    }

    
    static func lookAtActionsOfNotif(_ notifItem : NotifStruct){
        
        switch notifItem.action {
            
        //Начало игры:
        case  kActionStarted:
            
            break
            
        //Завершение приёма заявок и начало определения победител
        case kActionFinishing:
            
            
            break
            
        //Завершение определения победителей:
        case kActionCompleted:
            
            
            break
            
        //Игра продлена изза недостаточного количества игроков:
        case kActionProlong:
            
            
            break
            
        //Отчёт об игре:
        case kActionUpdate:
            
            break
            
        default: // kActionUndefined
            
            
            return
        }
        
        
    }
    
    
    
    static var numberOfFakeGamers: Int = 5
    
    static func sendFakeLocalPush(){
        
        if #available(iOS 10.0, *) {
            let timeInterval = 5.0
            let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { (timer) in
                sendFakeNotif()
            })
        }

    }
    static func sendFakeNotif(){
     
        numberOfFakeGamers = numberOfFakeGamers + 1
        
        let fake_data = ["action": kActionCompleted,//kActionCompleted,//kActionFinishing,//kActionUpdate,
            "message" : ["Game is over", "Игра закончилась"],
                         "data":
        [
            "ending_at" : "2017-11-08T08:00:00Z",
            "id" : 12,
            "num_players" : numberOfFakeGamers,
            "prize_amount" : 0.021 + 0.07 * Float(numberOfFakeGamers),
            "prize_amount_fiat" : 5.978490000000001 + 0.00007 * Float(numberOfFakeGamers),
            "smart_contract_id" : "0x677639717d4d6e69a263be77cb31c319a01df6ea",
            "started_at" : "2017-11-07T08:00:00Z",
            "status" : kStatusComplete,
            "type": kTypeDay,
            ]
        
        ] as [String : Any]
        parseNotificationAction(fake_data, .active)
        
    }
    
    
}
