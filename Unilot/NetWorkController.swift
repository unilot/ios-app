//
//  NetWorkController.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

let kServerApi = "https://dev.unilot.io/"

let kAPI_get_token      = "o2/token/"
let kAPI_set_device     = "api/v1/device/"
let kAPI_get_list_games = "api/v1/games"



let request_session_data  = [
    "client_id": "PccTjiTN7xXU9PCJRiAzYA2frgKUSEl0scJMTzFb",
    "client_secret": "2HIDVZRBWIDWUVMnlgH76K6pA3g5vPuAygnTm5P4IbvTkQMymFVCejMRoOkiZkadenWUsiM5OPP8mhREYytAxtzym9ejKj5LVG37z3mgbtrlJ1nMuv3s14sx60AuwwO1",
    "grant_type" : "client_credentials"
]

var request_headers = [
    "Content-Type": "application/x-www-form-urlencoded",
    "accept": "application/json",
]

class NetWork : AFNetworkController{

    static var shared = NetWork()
    
    func startSession(_ completion :  @escaping (String?) -> Void){
        
        doNetStuff(PATH:    kAPI_get_token,
                   TYPE:    kPOST,
                   VARS:    request_session_data,
                   ERROR:   completion,
                   FILL: { (responseDict:  [String : Any]!) in
            
                    token_session = responseDict["access_token"] as? String
                    
                    print("\n\nstartSession = " ,responseDict,"\n\n")

                    completion(token_session == nil ? "no access_token!" : nil)

        })
        
    }
    
    
    
    func getGamesList(_ completion: @escaping  (String?) -> Void) {
        
        doNetStuff(PATH:    kAPI_get_list_games,
                   TYPE:    kGET,
                   VARS:    nil,
                   ERROR:  completion,
                   FILL: { (responseDict:  [String : Any]!) in
                    
                    print("\n\ngetGamesList = " ,responseDict,"\n\n")
                    
                    completion(nil)
        })
 
        
    }
    
    
    
    
    func sendDevice(_ completion: @escaping (String?) -> Void){
        
        doNetStuff(PATH:   kAPI_set_device,
                   TYPE:   kPOST,
                   VARS :  ["device" : "iOS"],
                   ERROR:  completion,
                   FILL: { (responseDict:  [String : Any]!) in
                    
                    print("\n\n sendDevice = " ,responseDict,"\n\n")
                    
                    completion(nil)
        })
        
    }
 
    func setInits(){
        
        
        
    }
    
    
    
    func getTimeCountInfo(){
        
        
    
    }
    
    
    
    
    func getMoneyCountInfo(){
        
    }
    
}
