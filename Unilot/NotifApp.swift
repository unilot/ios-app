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
import Whisper


class NotifApp {
      
    
    static func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound])
            { (_ granted : Bool , _ error : Error?) in
                // actions based on whether notifications were authorized or not
               
                if granted {

                
                } else {
                     if error != nil {
                        _ = message_to_Crashlytics(error : error!)
//                        print("error push id " + error!.localizedDescription )
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

     
    
    //MARK: - SOME SMALL STUFF
    
    static func getDataFromNotifString(_ notifStr : String?, _ idOfData : Int) -> String {
        
        if notifStr == nil{
            return "0"
        }
 
        let parse_line =  notifStr!.components(separatedBy: "&")[idOfData]
        
        if parse_line == kEmpty {
            return "0"
        }
 
        return parse_line
    }
    
    
    static func removeNotifWithSameGameId( _ game_id : String){

        let new_filtered = notification_data.filter({
            return game_id != getDataFromNotifString($0, 1)
        })

        notification_data = new_filtered
        
        MemoryControll.setNotificationSaved()

    }
    
    static func getIdOfGameIfCompletedInMemory() -> String?{
        
        if open_from_notif == nil{
            return nil
        }
        
        let game_id = getDataFromNotifString(open_from_notif!,1)
        
        removeNotifWithSameGameId(game_id)
        
        return game_id
        
    }

    
    static func parseNotif(_ data : [String : Any]) -> NotifStruct {
        
        let notifItem = NotifStruct()
        
        notifItem.messages = data["message"] as? [String : String] ?? [:]
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
    
    //MARK: - LOCAL NOTIFICATION
    
    
    static func gotLocalUserNotifAnswer( _ notif : String){
        
        open_from_notif = notif
        current_controller_core?.onCheckAppNotifRecieved()
        
    }
    
    static func showLocalNotifInApp(withController : UINavigationController , _  notif : NotifStruct){
                
        let lCode = langCodes[current_language_ind]
        let typeId = getTabBarTag(notif.game.type)

        
        let message = notif.messages[lCode]!
        let title = TR(tabbar_strings[typeId]) + " " + TR("drawing1")
        let image = UIImage(named: lottery_images[typeId] + "-small")
        
        Whisper.show(shout: Announcement(title: title, subtitle: message, image: image),
                     to: withController,
                     completion: {
                        
                        print("showLocalNotifInApp closed ")
                        
        })
    }
    
    //MARK: - REMOTE NOTIFICATION
    
    static func parseRemoteNotification( _ notificationDictionary : [String : Any]){
        
//        print(notificationDictionary)
        
        if !app_is_active {
            
            MemoryControll.init_defaults_if_any()
        }
        
        
        // parse data from remote notification
        
        // fake push
        let notifItem = parseNotif(createFakePush())
        
        // real code
//        let notifItem = parseNotif(notificationDictionary)
 
        
        // if we have complete game status - save it and change Badge item
        if  notifItem.action == kActionCompleted{
            
            MemoryControll.saveNewNotif(notifItem.notif_id) 

        }
        
        
        // do something with these data if app is closed
        if !app_is_active {
            
            // if game id is in notification
            if notifItem.game.game_id != kEmpty {
                
                //  check for users settings of switching of notification
                if notifications_switch[getTabBarTag(notifItem.game.type)] {

                    // send notification from closed app
                    let lCode = langCodes[current_language_ind]
                    sendNotification(notifItem.messages[lCode]!, notifItem.notif_id)
                    
                 }
            }
            
        } else {

            // if game id is in notification
            if notifItem.game.game_id != kEmpty {
                
                games_list[notifItem.game.type] = notifItem.game

            }
            
            
            open_from_notif = notifItem.notif_id

            // do something with these data if app was launched
            current_controller_core?.onActiveAppNotifRecieved(notifItem)

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
    
    
    //MARK: -
    //MARK: - FAKE PUSHES
    
    
    static func sendFakeLocalPush(){
        
        if #available(iOS 10.0, *) {
            let timeInterval = 5.0
            
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { (timer) in
                sendFakeNotif()
            })
        }

    }
    
    static var numberOfFakeGamers: Int = 5
    
    static func sendFakeNotif(){
        
        numberOfFakeGamers = numberOfFakeGamers + 1
        
        parseRemoteNotification(createFakePush())
        
    }
    
    static func createFakePush() -> [String : Any] {
      
        return  ["action": kActionCompleted,//kActionCompleted,//kActionFinishing,//kActionUpdate,
            "message" : ["en":"Game is over", "ru":"Игра закончилась"],
            "data":
                [
                    "ending_at" : "2017-11-07T08:00:00Z",
                    "id" : 2,
                    "num_players" : numberOfFakeGamers,
                    "prize_amount" : 0.021 + 0.04 * Float(numberOfFakeGamers),
                    "prize_amount_fiat" : 5.978490000000001 + 0.00007 * Float(numberOfFakeGamers),
                    "smart_contract_id" : "0x677639717d4d6e69a263be77cb31c319a01df6ea",
                    "started_at" : "2017-11-07T08:00:00Z",
                    "status" : kStatusComplete,
                    "type": kTypeDay,
            ]
            
            ] as [String : Any]
    }
    

    
    
}
