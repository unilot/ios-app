//
//  MemoryControll.swift
//  Unilot
//
//  Created by Alyona on 10/12/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


var current_language = "English"
var notifications_switch = [false,false,true]
var users_account_number =  ["1231qewr4r124","Qwr34qwawerwt2345t4"]
var my_win_wallets = [UserForGame]()


var currentTabBarLottery = 0

var tokenForNotifications = kEmpty //"0xf49ebf9ac72767cf83a8969fe76acceb44855745"

var notification_data = [[String : Any]]()


class MemoryControll {
    
    
    static var lastchangesStr : String = "firstForTest"
    static var lastchangesStrOffer : String = "forOffersTMPRRs"
    static var keyFormsTMP : String = "forOffersTMPRRsu"

    
    
    static func init_defaults_if_any(){
        
        if let lang = getObject("current_language") as? Int {
            
            current_language = setting_strings[1][lang]
            Bundle.setLanguage(langCodes[lang])
            
        } else {

            let pre = Locale.preferredLanguages[0]
            
            let ind : Int  =  langCodes.index(of: pre) ?? 0
            
            current_language = setting_strings[1][ind]
            Bundle.setLanguage(langCodes[ind])

            saveObject(0, key: "current_language")
        }
        
        if let switchers = getObject("notifications_switch") as? [Bool] {
            notifications_switch = switchers
        } else {
            saveObject(notifications_switch, key: "notifications_switch")
        }
        
        if let array_of_numbers = getObject("users_account_number") as? [String] {
            users_account_number = array_of_numbers
        } else {
            saveObject(users_account_number, key: "users_account_number")
        }
        
        
        if let switchers = getObject("notifications_app") as? [[String : Any]] {
            notification_data = switchers
        } else {
            saveObject(notification_data, key: "notifications_app")
        }
        
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
    
 
    
}

