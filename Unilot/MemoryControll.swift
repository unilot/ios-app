//
//  MemoryControll.swift
//  Unilot
//
//  Created by Alyona on 10/12/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

var current_language_ind = 0

var notifications_switch = [true,true,true]
var users_account_number =  [String]()

var tokenForNotifications = kEmpty

var notification_data = [String]()

var open_from_notif : String?

var app_is_active : Bool = false

weak var current_controller_core : ControllerCore?

class MemoryControll {
    
    
    static var lastchangesStr : String = "firstForTest"
    static var lastchangesStrOffer : String = "forOffersTMPRRs"
    static var keyFormsTMP : String = "forOffersTMPRRsu"

    
    
    static func init_defaults_if_any(){

        getLanguages()
  
        getNotifSettings()

        getUsersWallets()
        
        getNotificationSaved()

    }
    
    
    static func getFirstLaunch(){
        
        if (getObject("launch_first") as? Int) != nil {
            
            open_from_notif = nil
            
        } else {
            
            open_from_notif = "&&\(kTypeProfile)"

            saveObject(Date().timeIntervalSince1970, key: "launch_first")

        }
    }
    
    static func getLanguages(){
        
        if let lang = getObject("current_language") as? Int {
            
            current_language_ind = lang
            
            Bundle.setLanguage(langCodes[lang])
            
        } else {
            
            let pre = Locale.preferredLanguages[0]
            
            let ind : Int  =  langCodes.index(of: pre) ?? 0

            setLanguage(ind)
        }
    }
    
    static func setLanguage(_ ind : Int){
        
        current_language_ind = ind
        
        Bundle.setLanguage(langCodes[current_language_ind])
            
        saveObject(current_language_ind, key: "current_language")
     }
    
    
    static func getNotifSettings(){
        
        if let switchers = getObject("notifications_switch") as? [Bool] {
            notifications_switch = switchers
        } else {
            saveObject(notifications_switch, key: "notifications_switch")
        }
    }
    
    
    static func getUsersWallets(){
        
        if let array_of_numbers = getObject("users_account_number") as? [String] {
            users_account_number = array_of_numbers
        } else {
            saveObject(users_account_number, key: "users_account_number")
        }
        
    }
    
    
    static func getNotificationSaved(){
        if let data = getObject("notifications_app") as? [String] {
            notification_data = data
        } else {
            saveObject(notification_data, key: "notifications_app")
        }
        
        UIApplication.shared.applicationIconBadgeNumber = notification_data.count

    }
    
    static func setNotificationSaved(){
        
        saveObject(notification_data, key: "notifications_app")
        
        UIApplication.shared.applicationIconBadgeNumber = notification_data.count
        
    }
    
    static func getObject(_ key: String) -> Any? {
        
        if let numback = UserDefaults.standard.object(forKey: key){
            
            return  NSKeyedUnarchiver.unarchiveObject(with: numback as! Data)
        }
        
        return nil
    }
    
    
    static func saveObject(_ obj: Any, key: String){
        
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: obj),
                                  forKey:key)
        UserDefaults.standard.synchronize()
        
    }
    
    
    static func removeObject(  _ key: String){
        
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    static  func setNewPredicate(){
        
        if let rName = UserDefaults.standard.string(forKey: "PredicateCacheWord") {
            
            removeCache(rName)
        }
        
        let  dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm"
        
        let date = Date(timeIntervalSinceReferenceDate: 162000)
        
        lastchangesStrOffer = "PredStart_" + dateFormatter.string(from: date) + "_"
        
        UserDefaults.standard.set(lastchangesStrOffer, forKey: "PredicateCacheWord")
        
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
    
    
    static  func getTimeStamp() -> String {
        
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        
        return timestamp
    }
    
    
    static func keyOfFormsStuff(_ nameOfVIew: String, specLang langSpec : String? = nil) -> String {
        
        return  keyFormsTMP + ".Forms." + nameOfVIew
    }
    
    
    static func saveNewNotif(_ notificationDictionary : String ){

        notification_data.append( notificationDictionary )
        
        UIApplication.shared.applicationIconBadgeNumber = notification_data.count

        MemoryControll.saveObject(notification_data, key: "notifications_app")
        
    }
    
    
    //mark: - spec

    static func saveGameMoneyStart(_ newMeaning : Int, _ game : GameInfo){
        
        MemoryControll.saveObject( newMeaning,  key: "gameTimeLeft" + game.game_id)
        
        local_current_game = game
        local_current_game.prize_amount_local  = newMeaning
        games_list[game.type]?.prize_amount_local = newMeaning
    }
}

