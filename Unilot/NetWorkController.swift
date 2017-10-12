//
//  NetWorkController.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import Alamofire


let request_session_data : Parameters = [
    "client_id": "PccTjiTN7xXU9PCJRiAzYA2frgKUSEl0scJMTzFb",
    "client_secret": "2HIDVZRBWIDWUVMnlgH76K6pA3g5vPuAygnTm5P4IbvTkQMymFVCejMRoOkiZkadenWUsiM5OPP8mhREYytAxtzym9ejKj5LVG37z3mgbtrlJ1nMuv3s14sx60AuwwO1",
    "grant_type" : "client_credentials"
]

var request_headers = [ "Content-Type": "application/json"]

var session_data = [String: Any]()


class NetWork {
    
   static func startSession(completion: @escaping (String?) -> Void) {
 
    Alamofire.request("https://dev.unilot.io/o2/token/",
                      method : .post,
                      parameters: request_session_data,
                      encoding: JSONEncoding.default,
                      headers: request_headers)
        .responseJSON { (response) -> Void in
            
            guard response.result.isSuccess else {
                let error_line = response.result.error!.localizedDescription
                completion(error_line)
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("empty responseJSON")
                return
            }
            
            session_data = responseJSON
            let new_header_item = String(format: (responseJSON["token_type"] as! String) + "  " + (responseJSON["access_token"] as! String))
            request_headers["Authorization"] = new_header_item
            
//            print("session_data = " ,responseJSON)

            completion(nil)
    }
    
    }
    
    static func getGamesList(completion: @escaping (String?) -> Void) {
    
//        request_headers["Authorization"] = "Bearer rGkj2wLQNYUkIIj71ohO4AGXarwejY"
        
        Alamofire.request("https://dev.unilot.io/api/v1/games",
                          method : .get,
                          encoding: JSONEncoding.default,
                          headers:request_headers)
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    let error_line = response.result.error!.localizedDescription
                    completion(error_line)
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any] else {
                    completion("empty responseJSON")
                    return
                }
                
//                print("allHTTPHeaderFields = " , response.request!.allHTTPHeaderFields)

                print("getGamesList = " ,responseJSON)
                
                completion(nil)
        }
    
    }
    
    func setInits(){
        
        
        
    }
//    
//    func getAlphabetList(_ params : [String:Any], FILL haveResult :((_ message: String?, _ answer:  [String:[CharityStruct]]?) -> Void)? = nil){
//
//    }
    
    
    static func getTimeCountInfo(){
        
        
    
    }
    
    
    
    static func getMoneyCountInfo(){
        
    }
    
}
