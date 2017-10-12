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

var request_headers = [
//    "Accept": "application/json"
    "Content-Type": "application/json"
//    "Content-Type": "application/x-www-form-urlencoded"
//    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"

]

var session_data = [String: Any]()

var my_tokens = ["1231qewr4r124","Qwr34qwawerwt2345t4"]

var notifications_switch = [true,false,true]



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
//                print(response.result.error!.localizedDescription)
                completion(error_line)
                
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                completion("empty responseJSON")
                return
            }
            
//            print(responseJSON)

            session_data = responseJSON
            let new_header_item = String(format: (responseJSON["token_type"] as! String) + "  " + (responseJSON["access_token"] as! String))
            request_headers["Authorization"] = new_header_item
 
            completion(nil)
    }
    
    }
    
    static func getGamesList(completion: @escaping (String?) -> Void) {
    
        Alamofire.request("https://dev.unilot.io/o2/token/",
                          method : .post,
                          parameters: request_session_data,
                          encoding: JSONEncoding.default,
                          headers: request_headers)
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    let error_line = response.result.error!.localizedDescription
                    
                    
                    print(response.result.error!.localizedDescription)
                    completion(error_line)
                    
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any] else {
                    completion("empty responseJSON")
                    return
                }
                
                print(responseJSON)
                
                session_data = responseJSON
                let new_header_item = String(format: (responseJSON["token_type"] as! String) + "  " + (responseJSON["access_token"] as! String))
                request_headers["Authorization"] = new_header_item
                print(request_headers)
                
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
