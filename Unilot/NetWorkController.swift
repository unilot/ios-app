//
//  NetWorkController.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import Alamofire

let kServer                 = "https://dev.unilot.io/"

let kAPI_get_token          = "o2/token/"
let kAPI_set_device         = "api/v1/device/"
let kAPI_get_list_games     = "api/v1/games"
let kAPI_get_list_winners   = "api/v1/games/%@/winners"
let kAPI_get_history        = "api/v1/games/archived"
let kAPI_post_notif_token   = "api/v1/device/"
let kAPI_get_game_details   = "api/v1/games/"


let request_session_data : Parameters = [
    "client_id": "PccTjiTN7xXU9PCJRiAzYA2frgKUSEl0scJMTzFb",
    "client_secret": "2HIDVZRBWIDWUVMnlgH76K6pA3g5vPuAygnTm5P4IbvTkQMymFVCejMRoOkiZkadenWUsiM5OPP8mhREYytAxtzym9ejKj5LVG37z3mgbtrlJ1nMuv3s14sx60AuwwO1",
    "grant_type" : "client_credentials"
]

var request_headers : HTTPHeaders  = [
    "Content-Type" : "application/json"
]



class NetWork : NetWorkParse {
 
    static func startSession(completion: @escaping (String?) -> Void) {
         
        Alamofire.request(kServer + kAPI_get_token,
                          method: HTTPMethod.post,
                          parameters: request_session_data,
                          encoding: JSONEncoding.default,
                          headers: request_headers)
            .responseJSON { (response) -> Void in
                
                completion(sendToErrorParsAndDataParse(response, parseAuthorisation))
        }
    }
    
    static func postNotifToken(completion: @escaping (String?) -> Void) {
        
        if tokenForNotifications == kEmpty{
            
            completion(nil)
            
        } else {
            
            let params : Parameters = ["os" : 10, "token" :  tokenForNotifications]
            
            Alamofire.request(kServer + kAPI_post_notif_token,
                              method: HTTPMethod.post,
                              parameters: params,
                              encoding: JSONEncoding.default,
                              headers: request_headers)
                .responseJSON { (response) -> Void in
                    
                    completion(sendToErrorParsAndDataParse(response, parseNotificationToken))
            }
            
        }
        

    }
    
    
    static func getGamesList(completion: @escaping (String?) -> Void) {
        
        Alamofire.request( kServer + kAPI_get_list_games,
                               method : .get,
                               encoding: JSONEncoding.default,
                               headers: request_headers)
            
            .responseJSON { (response) -> Void in
                
                completion(sendToErrorParsAndDataParse(response, parseGamesList, "list_games"))

                
        }
        
    }
    
    
    static func getListWinners(completion: @escaping (String?) -> Void) {
        
        let gameId = local_current_game.game_id
        
        print("local_current_game.game_id ", gameId)
        Alamofire.request( String(format:kServer + kAPI_get_list_winners, gameId),
                           method : .get,
                           encoding: JSONEncoding.default,
                           headers: request_headers)
            
            .responseJSON { (response) -> Void in
                
                completion(sendToErrorParsAndDataParse(response, parseWinnersList,"winners_" + gameId))
        }
        
    }
    
    
    
    static func getHistoryPage(completion: @escaping (String?) -> Void) {
        
        Alamofire.request( kServer + kAPI_get_history,
                           method : .get,
                           encoding: JSONEncoding.default,
                           headers: request_headers)
            
            .responseJSON { (response) -> Void in

                completion(sendToErrorParsAndDataParse(response, parseHistoryPage, "history"))
        }
        
    }
    
    
    
    static func getGameDetails(_ gameNumber : String, completion: @escaping (String?) -> Void) {
        
        Alamofire.request( kServer + kAPI_get_game_details + gameNumber,
                           method : .get,
                           encoding: JSONEncoding.default,
                           headers: request_headers)
            
            .responseJSON { (response) -> Void in
                
                completion(sendToErrorParsAndDataParse(response, parseGameDetails, "game_" + gameNumber ))
        }
        
    }
    
    
    //MARK: - ERRORS
    
    static func sendToErrorParsAndDataParse(
                            _ response       : DataResponse<Any>,
                            _ dataParse      : ((Any?) -> String?),
                            _ keyForSavings  : String? = nil) -> String? {
        
        print(response)
        
        guard (response.result.isSuccess) &&  (response.result.value != nil) else {
            
            var answer : String? = nil

            if response.result.error != nil {
                answer = response.result.error!.localizedDescription
            } else {
                answer = "response.result.value is NULL"
            }
            
            if keyForSavings != nil {
                 _ = dataParse( MemoryControll.getObject(keyForSavings!)!)
            }
            
            return answer

        }
        
        let dataForDetails = response.result.value!
        
        if keyForSavings != nil {
            
            MemoryControll.saveObject(dataForDetails, key: keyForSavings!)
 
        }
        
        return dataParse(dataForDetails)

        
    }
    

    

}
