//
//  NetWorkController.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import Alamofire
 
let kServerDEV                 = "https://dev.unilot.io/"
let kServerPROD                = "https://api.unilot.io/"

let request_session_data_DEV : Parameters = [
    "client_id": "PccTjiTN7xXU9PCJRiAzYA2frgKUSEl0scJMTzFb",
    "client_secret": "2HIDVZRBWIDWUVMnlgH76K6pA3g5vPuAygnTm5P4IbvTkQMymFVCejMRoOkiZkadenWUsiM5OPP8mhREYytAxtzym9ejKj5LVG37z3mgbtrlJ1nMuv3s14sx60AuwwO1",
    "grant_type" : "client_credentials"
]

let request_session_data_PROD : Parameters = [
    "client_id": "ZACP3xcutFCuHYNMQNnYChEWr4xLVuXBWbQRAgw0",
    "client_secret": "y89eVMS5a4cVQ8YpxAb8r1EhJq2IwKxMyaDu17Rq1Ah8nJPEbKvsuU12b0OVYJtR7Xafyq1VfSFEvN1t5WVHyYCyRPAnOHmQijSLWyUgb9IHbU0pjQPhofq5kobMviFf",
    "grant_type" : "client_credentials"
]







let kAPI_get_token          = "o2/token/"

let kAPI_set_device         = "api/v1/device/"
let kAPI_get_list_games     = "api/v1/games"
let kAPI_get_list_winners   = "api/v1/games/%@/winners"
let kAPI_get_history        = "api/v1/games/archived"
let kAPI_post_notif_token   = "api/v1/device/"
let kAPI_get_game_details   = "api/v1/games/"



let kServer                 =  is_mod_production ? kServerPROD : kServerDEV

let request_session_data    =  is_mod_production ? request_session_data_PROD :request_session_data_DEV



var request_headers : HTTPHeaders  = [
    "Content-Type"  : "application/json",
    "Api-Version"   : current_version,
]



class NetWork : NetWorkParse {
 
    static func startSession(completion: @escaping (String?) -> Void) {
        
        Alamofire.request(kServer + kAPI_get_token,
                          method: HTTPMethod.post,
                          parameters: request_session_data,
                          encoding: JSONEncoding.default,
                          headers: request_headers)
            .responseJSON { (response) -> Void in
                
                error_or_success(response, parseAuthorisation,completion)
        }
    }

    static func postNotifToken(completion: @escaping (String?) -> Void) {
        
        guard ( tokenForNotifications != kEmpty)  else {
           
            completion(nil)
        
            return
        }
   
        let params : Parameters = ["os" : 10, "token" :  tokenForNotifications]
        
        Alamofire.request(kServer + kAPI_post_notif_token,
                          method: HTTPMethod.post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: request_headers)
            .responseJSON { (response) -> Void in
                
                error_or_success(response, parseNotificationToken,completion)
        }
        
  
    }
     
    
    static func getGamesList(completion: @escaping (String?) -> Void) {
        
        Alamofire.request( kServer + kAPI_get_list_games,
                               method : .get,
                               encoding: JSONEncoding.default,
                               headers: request_headers)
            
            .responseJSON { (response) -> Void in
                
               error_or_success(response, parseGamesList, completion, "list_games")

                
        }
        
    }
    
    
    static func getListWinners(_ gameId : String, completion: @escaping (String?) -> Void) {
        
         Alamofire.request( String(format:kServer + kAPI_get_list_winners, gameId),
                           method : .get,
                           encoding: JSONEncoding.default,
                           headers: request_headers)
            
            .responseJSON { (response) -> Void in
                
                error_or_success(response, parseWinnersList, completion, "winners_" + gameId)
        }
        
    }
    
    
    
    static func getHistoryPage(completion: @escaping (String?) -> Void) {
        

        Alamofire.request( kServer + kAPI_get_history,
                           method : .get,
                           encoding: JSONEncoding.default,
                           headers: request_headers)
            
            .responseJSON { (response) -> Void in

                error_or_success(response, parseHistoryPage, completion,"history")
        }
        
    }
    
    
    
    static func getGameDetails(_ gameNumber : String, completion: @escaping (String?) -> Void) {
        
        Alamofire.request( kServer + kAPI_get_game_details + gameNumber,
                           method : .get,
                           encoding: JSONEncoding.default,
                           headers: request_headers)
            
            .responseJSON { (response) -> Void in
                
                error_or_success(response, parseGameDetails, completion, "game_" + gameNumber)
 
                
        }
        
    }
    
    
    //MARK: - ERRORS
    
    static func error_or_success(
                            _ response       : DataResponse<Any>,
                            _ dataParse      : @escaping ((Any?) -> String?),
                            _ completion     : @escaping ((String?) -> Void),
                            _ keyForSavings  : String? = nil) {
        
        print(response)
        
        // token was old
        guard (response.response?.statusCode != 401) else {
          
            startSession(completion: { (error : String? ) in
                if error == nil {

                    var oldRequest = response.request!
                    oldRequest.allHTTPHeaderFields = request_headers

                    Alamofire.request(oldRequest).responseJSON { (response) -> Void in
                        
                        error_or_success(response, dataParse, completion, keyForSavings)
                    
                    }
                    
                } else {
                    
                    completion(TR("Ошибка соединения, пожалуйста повторите запрос"))

                }
            })
            
            return
        }
        
        // need upgrade
        guard (response.response?.statusCode != 417) else {
            
            if response.result.error != nil {
                completion(response.result.error?.localizedDescription)
            }
            
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            let viewController = appDelegate.window!.rootViewController
            return
        }
        
        // some connection error
        guard (response.result.isSuccess) && (response.result.value != nil) else {
            
            var answer : String? = nil

            if response.result.error != nil {
                answer = dev_messagesShowed(error : response.result.error!)
            } else {
                answer = dev_messagesShowed(line : "response.result.value is NULL")
            }
            
            if keyForSavings != nil {
                 _ = dataParse( MemoryControll.getObject(keyForSavings!)!)
            }
            
            completion(answer)

            return
        }
        
        
        let dataForDetails = response.result.value!
        
         if keyForSavings != nil {
            
            MemoryControll.saveObject(dataForDetails, key: keyForSavings!)
 
        }
        
        let answer = dataParse(dataForDetails)
        
        completion(answer)

    }
    

    

}
