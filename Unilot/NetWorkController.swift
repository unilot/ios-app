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

var request_headers = [
    "Content-Type": "application/json",
    "Accept": "application/json"

]

var session_data = [String: Any]()


class NetWork {
    
//    static let serverTrustPolicies: [String: ServerTrustPolicy] = [
//        //        "dev.unilot.io": .pinCertificates(
//        //            certificates: ServerTrustPolicy.certificates(),
//        //            validateCertificateChain: true,
//        //            validateHost: true
//        //        ),
//        //        "https://dev.unilot.io": .disableEvaluation
//    ]
//    
//    static let sessionManager = SessionManager(
//        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//    )
//    
    
    
    static func test(){
        let headers = [
            "Authorization": "Bearer Zk7vI5Ur9LTRKdXpTELWiUwr2zFzxE",
            "Authenticate": "Bearer Zk7vI5Ur9LTRKdXpTELWiUwr2zFzxE",
            "accept"       :  "application/json",
            "Content-Type" :"application/json"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://dev.unilot.io/api/v1/games")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("test error\n", error?.localizedDescription ?? "fghjk")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("test httpResponse\n",httpResponse ?? "poiuytre")
            }
        })
        
        dataTask.resume()
    }
    static func startSession(completion: @escaping (String?) -> Void) {
        
//        test()
        
        Alamofire.request(kServer + kAPI_get_token,
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
                
                print("session_data = " ,responseJSON)
                
                completion(nil)
        }
        
    }
    
    
    static func getGamesList(completion: @escaping (String?) -> Void) {
        
        
        let urlPath = URL(string:  kServer + kAPI_get_list_games)!
        let rightURL = urlPath.appendingPathComponent("?token=uMoRQBh051A6pbmmNMj88nMyWAXRkM")

        Alamofire.request(rightURL,
                               method : .get,
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
                
                                print("allHTTPHeaderFields = " , response.request!.urlRequest)
                
                                print("getGamesList = " ,responseJSON)
                
                completion(nil)
        }
        
    }
    
    
    static func getLotteryDetails(_ completion: ([[String:String]]) -> Void,
                                  _ fail_request: @escaping (String?) -> Void) {

        
        
        var dataForTable = [[String:String]]()
     
        // debug
        
        for i in 0..<234{
            
            var item = [String:String]()
            
            item["place"] = "\(i + 1)"
            item["key"] = "\(i * 32349545)".base64Encoded()
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
    
}
