//
//  MemoryControll.swift
//  Unilot
//
//  Created by Alyona on 10/12/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

var current_language_ind = 0

var notifications_switch = [true,true,true,true]

var users_account_wallets =  [Wallet]()

var tokenForNotifications = kEmpty

var notification_data = [String]()

var open_from_notif : String?

var app_is_active : Bool = false

weak var current_controller_core : ControllerCore?

class MemoryControll {
    
    static var lastchangesStr : String = "12345947890314"
    
    
    //MARK: - DEFAULTS init
    
    static func init_defaults_if_any(){

        getFirstLaunch()
        
        getLanguages()
  
        getNotifSettings()

        getUsersWallets()
        
        getNotificationSaved()

        app_is_active = true

    }
    
  
    static func getLanguages(){
        
        if let lang = getObject("current_language") as? Int {
            
            current_language_ind = lang
            
            Bundle.setLanguage(langCodes[lang])
            
        } else {
            
            let pre : String = Locale.current.languageCode ?? "en"
            
            let ind : Int  =  langCodes.index(of: pre) ?? 0

            setLanguage(ind)
        }
    }


    static func getNotifSettings(){
        
        if let switchers = getObject("notifications_switch") as? [Bool] {
            notifications_switch = switchers
        } else {
            saveDeviceSettings()
        }
    }
    
    
    static func getUsersWallets(){
        
        // #removeNextBuild#
        if let array_of_numbers = getObject("users_account_number") as? [String] {

            for contract_id in array_of_numbers{
                let wallet = Wallet()
                wallet.smart_contract_id = contract_id
                users_account_wallets.append(wallet)
            }
            
            saveWalletsInMemory()
            
            removeObject("users_account_number")
            
            return
            
            
        }
        // #removeNextBuild#
 
        
        if let array_of_numbers = getObject("users_account_wallets") as? [Wallet] {
            users_account_wallets = array_of_numbers
        } else {
            saveWalletsInMemory()
        }
        
    }
    
    
   static func saveWalletsInMemory(){
    
        saveObject(users_account_wallets, key: "users_account_wallets")
        
    }
    
    //MARK: - App stuff

    
    static func getFirstLaunch(){
        
        if (getObject("launch_first") as? String) != nil {
            
            open_from_notif = nil
            
        } else {
            
            open_from_notif =  default_first_launch
            
            saveObject("\(current_api_version) \(Date().timeIntervalSince1970)", key: "launch_first")
            
        }
    }
    
    static func setLanguage(_ ind : Int){
        
        current_language_ind = ind
        
        Bundle.setLanguage(langCodes[current_language_ind])
        
        saveObject(current_language_ind, key: "current_language")
    }
    
    //MARK: - NOTIFICATIONS

    
    static func setNotificationSaved(){
        
        UserDefaults.init(suiteName: "group.unilot")?.set(notification_data, forKey: "notifications")
        
        UIApplication.shared.applicationIconBadgeNumber = notification_data.count
        UIApplication.shared.cancelAllLocalNotifications()

    }

    static func getNotificationSaved(){
        
        
        if let data = UserDefaults.init(suiteName: "group.unilot")?.value(forKey: "notifications") as? [String] {
//        if let data = getObject("notifications_app") as? [String] {
            notification_data = data
        }
        
    }
    
    //MARK: -
    
    
    static func saveNewNotif(_ newNotif : String ){
        
        getNotificationSaved()
        

        if !notification_data.contains(newNotif) {
            
            notification_data.append( newNotif )
            setNotificationSaved()
        }
        
  
        
    }
    
    
    static func saveGameMoneyStart(_ newMeaning : Int, _ game_id : String){
        
        saveObject( newMeaning,  key: "gameTimeLeft" + game_id)

    }
    
    static func getGameMoneyStart(_ game_id : String) -> Int{
        
        if let local_meanings = getObject("gameTimeLeft" + game_id) as? Int {
            return local_meanings
        }
        
        return 0
    }
    
    //MARK: - memory stuff

    
    static func getObject(_ key: String) -> Any? {
        
        if let numback = UserDefaults.standard.object(forKey: key + lastchangesStr){
            
            return  NSKeyedUnarchiver.unarchiveObject(with: numback as! Data)
        }
        
        return nil
    }
    
    
    static func saveObject(_ obj: Any, key: String){
        
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: obj),
                                  forKey:key + lastchangesStr)
        UserDefaults.standard.synchronize()
        
    }
    
    
    static func removeObject(  _ key: String){
        
        UserDefaults.standard.removeObject(forKey: key + lastchangesStr)
        UserDefaults.standard.synchronize()
        
    }
    
    //MARK: - tech stuff
    
    static  func setNewPredicate(){
        
        if let rName = UserDefaults.standard.string(forKey: "PredicateCacheWord") {
            
            removeCache(rName)
        }
        
        let  dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm"
        
        let date = Date(timeIntervalSinceReferenceDate: 162000)
        
        lastchangesStr = "PredStart_" + dateFormatter.string(from: date) + "_"
        
        UserDefaults.standard.set(lastchangesStr, forKey: "PredicateCacheWord")
        
        UserDefaults.standard.synchronize()
        
    }
    
    
    static  func removeCache(_ predString : String){
        let pred = NSPredicate(format: "SELF BEGINSWITH %@", predString)
        let dictKeys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
        
        for key in dictKeys {
            if pred.evaluate(with: key) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        
        
    }

}
