//
//  NetWorkController.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import Alamofire

let kServer = "https://dev.unilot.io/"

let kAPI_get_token      = "o2/token/"
let kAPI_set_device     = "api/v1/device/"
let kAPI_get_list_games = "api/v1/games"


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
    
    
    static func getGamesList(completion: @escaping (String?) -> Void) {
        
        Alamofire.request( kServer + kAPI_get_list_games,
                               method : .get,
                               encoding: JSONEncoding.default,
                               headers: request_headers)
            
            .responseJSON { (response) -> Void in
                
                completion(sendToErrorParsAndDataParse(response, parseGamesList))
        }
        
    }
    
    
    static func getLotteryDetails(_ completion: ([[String:String]]) -> Void,
                                  _ fail_request: @escaping (String?) -> Void) {

        
        
        var dataForTable = [[String:String]]()
     
        // debug
        
        for i in 0..<234{
            
            var item = [String:String]()
            
            item["place"] = "\(i + 1)"
            item["key"] = "\(i * 3234955)".base64Encoded()
            item["eth"] = "\(Float(234 - i) * 1.2)"
            item["usd"] = "\(Float(234 - i) * 0.0008)"
            
            dataForTable.append(item)

        }
        
        completion(dataForTable)
        
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
    
    //MARK: - ERRORS
    
    static func sendToErrorParsAndDataParse(
                            _ response      : DataResponse<Any>,
                            _ dataParse     : (Any?) -> String? ) -> String? {
        
        guard response.result.isSuccess else {
            return  response.result.error!.localizedDescription
        }
        
        // some othe error check
        
        if  response.result.value == nil  {
            return  "response.result.value is NULL"
        }
        
        // parse usefull data
        
        return dataParse( response.result.value)
        
    }
    
    
    
}
