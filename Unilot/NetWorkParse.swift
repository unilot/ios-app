//
//  NetWorkParse.swift
//  Unilot
//
//  Created by Alyona on 10/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import Foundation
 
var notifications_data = ["badge" : 3]

var session_data = [String: Any]()

var games_list = [[String:Any]]()


class NetWorkParse {
     
    static func parseAuthorisation(_ resultValue : Any) -> String? {
        
        guard let responseJSON = resultValue as? [String: Any] else {
            return "Wrong json format for parseAuthorisation"
        }
        
        session_data = responseJSON
        
        let tokenType: String = responseJSON["token_type"] as! String
        let tokenMeaning: String = responseJSON["access_token"] as! String
        
        request_headers["Authorization"] = tokenType + " " + tokenMeaning
        
        return nil
    }

    static func parseGamesList(_ resultValue : Any) -> String? {
        
        guard let responseJSON = resultValue as? [[String:Any]] else {
            return "Wrong json format for parseGamesList"
        }
        
        games_list = responseJSON
        
        print(resultValue)

        return nil
        
    }
    
}
