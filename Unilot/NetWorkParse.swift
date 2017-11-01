//
//  NetWorkParse.swift
//  Unilot
//
//  Created by Alyona on 10/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import Foundation
 
 
var session_data = [String: Any]()

var games_list = [Int : GameInfo]()

var winners_list = [UserForGame]()

var history_list = [GameInfo]()


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

    static func parseNotificationToken(_ resultValue : Any) -> String? {
        
        guard resultValue is [String: Any] else {
            return "Wrong json format for parseNotificationToken"
        }
        
        
        return nil
    }
    
    
    static func parseGamesList(_ resultValue : Any) -> String? {

        guard let responseJSON = resultValue as? [[String:Any]] else {
            return "Wrong json format for parseGamesList"
        }

        games_list = [:]
        
        for item in responseJSON {
            let game = createGameItem(from: item)
            games_list[game.type] = game
         }
        
        return nil
        
    }
    
    
    static func parseWinnersList(_ resultValue : Any) -> String? {
        
        guard let responseJSON = resultValue as? [[String:Any]] else {
            return "Wrong json format for parseWinnersList"
        }
        
        winners_list = []
        
        for item in responseJSON {
            let game = createUserItemForGame(from: item)
            winners_list.append(game)
        }
        
        return nil
        
    }
    
    static func parseHistoryPage(_ resultValue : Any) -> String? {

        guard let responseJSON = resultValue as? [[String:Any]] else {
            return "Wrong json format for parseHistoryPage"
        }
        
        history_list = []
        
        for item in responseJSON {
            let game = createGameItem(from: item)
            history_list.append(game)
        }
        
        return nil
        
    }
    
    
    static func parseGameDetails(_ resultValue : Any) -> String?{
        
        guard let responseJSON = resultValue as? [String:Any] else {
            return "Wrong json format for parseGameDetails"
        }
        
        
        local_current_game = createGameItem(from: responseJSON)
        
        return nil
        
    }
    
    
    //MARK: - fill items
    
    static func createGameItem(from data :[String : Any]) -> GameInfo{
            
        let item = GameInfo()
        
        item.game_id            = "\(data["id"]!)"
        item.smart_contract_id  = data["smart_contract_id"] as! String
        item.num_players        = data["num_players"] as! Int
        item.prize_amount       = data["prize_amount"] as! Float
        item.prize_amount_fiat  = data["prize_amount_fiat"] as! Float
        item.started_at         = convertDate(from: data["started_at"] as! String)
        item.ending_at          = convertDate(from: data["ending_at"] as! String)
        item.status             = data["status"] as! Int
        item.type               = data["type"] as! Int
        
        
        let keyLine = "gameTimeLeft" + item.game_id
        if let localPrize = MemoryControll.getObject(keyLine) as? Int {
            
            let data_saved = Float(localPrize) / 1000.0
            
            if data_saved > item.prize_amount_fiat {
                
                MemoryControll.removeObject(keyLine)
                
            } else {
                
                item.prize_amount_local = localPrize
   
            }
         }
        
        return item
    }

    
    
    static func createUserItemForGame(from data :[String : Any]) -> UserForGame{
        
        let item = UserForGame()
        
        item.user_id            = data["address"] as! String
        item.position           = data["position"] as! Int
        item.prize_amount       = data["prize_amount"] as! Float
        item.prize_amount_fiat  = data["prize_amount_fiat"] as! Float
        
        return item
    }


    
}
