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
    
//    static let serverTrustPolicies: [String: ServerTrustPolicy] = [
////        "dev.unilot.io": .pinCertificates(
////            certificates: ServerTrustPolicy.certificates(),
////            validateCertificateChain: true,
////            validateHost: true
////        ),
////        "https://dev.unilot.io": .disableEvaluation
////    ]
//    
//    static let sessionManager = SessionManager(
//        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//    )
    
    
    static func test(){
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
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
            request_headers["authorization"] = new_header_item
            
//            print("session_data = " ,responseJSON)

            completion(nil)
    }
    
    }
    
    static func sendDevice(completion: @escaping (String?) -> Void){
        
        Alamofire.request("https://dev.unilot.io/api/v1/device/",
                          method : .post,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: request_headers)
            
            .responseJSON { (response) -> Void in
                
                completion(nil)
        }
    }
    
    static func getGamesList(completion: @escaping (String?) -> Void) {
        
        let urlString = "https://dev.unilot.io/api/v1/games"
//        let urlString = "https://httpbin.org/get"
        let headers = ["Authorization": "Bearer SR6XJOlJu6sIgD5lN6q7BLq1heoDGJ"]
        
        // When
        
        Alamofire.request(urlString, method: .get, headers: headers)

        
        
//        Alamofire.request("https://dev.unilot.io/api/v1/games",
//                          method : .get,
//                          parameters: nil,
//                          encoding: URLEncoding.default,
//                          headers: request_headers)
//
//            .responseJSON { (response) -> Void in
//                
//                guard response.result.isSuccess else {
//                    let error_line = response.result.error!.localizedDescription
//                    completion(error_line)
//                    return
//                }
//                
////                guard let responseJSON = response.result.value as? [String: Any] else {
////                    completion("empty responseJSON")
////                    return
////                }
//                
////                print("allHTTPHeaderFields = " , response.request!.urlRequest)
//
////                print("getGamesList = " ,responseJSON)
//                
//                completion(nil)
//        }
    
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
