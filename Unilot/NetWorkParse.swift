//
//  NetWorkParse.swift
//  Unilot
//
//  Created by Alyona on 10/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import Foundation
import Firebase
import Crashlytics

var session_data = [String: Any]()

var games_list = [Int : GameInfo]()

var winners_list = [UserForGame]()

var history_list = [GameInfo]()


class NetWorkParse {
     
    static func parseAuthorisation(_ resultValue : Any) -> String? {
        
        guard let responseJSON = resultValue as? [String: Any] else {
            return message_to_Crashlytics(line : "Authorisation")
        }
        
        session_data = responseJSON
        
        let tokenType       = responseJSON["token_type"] as? String ?? "Bearer"
        let tokenMeaning    = responseJSON["access_token"] as? String ?? "empty_token_key"
        
        request_headers["Authorization"] = tokenType + " " + tokenMeaning
        
        return nil
    }

    static func parseNotificationToken(_ resultValue : Any) -> String? {
        
        guard resultValue is [String: Any] else {
            return message_to_Crashlytics(line : "NotificationToken")
        }
       
        
        return nil
    }
 
    static func parseDeviceSettings(_ resultValue : Any) -> String? {
        
        guard resultValue is [String: Any] else {
            return message_to_Crashlytics(line : "NotificationToken")
        }
        
        
        return nil
    }
    
    static func parseGamesList(_ resultValue : Any) -> String? {

        guard let responseJSON = resultValue as? [[String:Any]] else {
            return message_to_Crashlytics(line : "GamesList")
        }

        games_list = [:]
        
        for item in responseJSON {
            let game = createGameItem(from: item)
            games_list[game.type] = game
         }
        
//        games_list[kTypeMonth] = createGameItem(from: responseJSON[1])
//        games_list[kTypeMonth]?.type = kTypeMonth
//
//        games_list[kTypeToken] = createGameItem(from: responseJSON[1])
//        games_list[kTypeToken]?.type = kTypeToken
//        games_list[kTypeToken]?.prize_currency = "UNIT"

        return nil
        
    }
    
    
    static func parseWinnersList(_ resultValue : Any) -> String? {
        
        guard let responseJSON = resultValue as? [[String:Any]] else {
            return message_to_Crashlytics(line: "WinnersList")
        }
        
        winners_list = []
        
        for item in responseJSON {
            let game = createUserItemForGame(from: item)
            winners_list.append(game)
        }
        
        return nil
        
    }
    
    static func parseParticipantsList(_ resultValue : Any) -> String? {
        
        guard let responseJSON = resultValue as? [[String:Any]] else {
            return message_to_Crashlytics(line: "ParticipantsList")
        }
        
        winners_list = []
        
        for item in responseJSON {
            let game = createUserItemForGame(from: item)
            winners_list.append(game)
        }
        
        return nil
        
    }
    
    static func parseHistoryPage(_ resultValue : Any) -> String? {

//        Crashlytics.sharedInstance().crash()

        guard let responseJSON = resultValue as? [[String:Any]] else {
            return message_to_Crashlytics(line: "HistoryPage")
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
            return message_to_Crashlytics(line: "GameDetails")
        }
        
        
        local_current_game = createGameItem(from: responseJSON)
        
        return nil
        
    }
    
    
    //MARK: - fill items
    
    static func createGameItem(from data :[String : Any] ) -> GameInfo{
            
        let item = GameInfo()
       
        
//            "amount": 1000000
//            "currency": "ETH"
        
        
        item.game_id            = "\(data["id"] ?? kEmpty )"
        item.smart_contract_id  = data["smart_contract_id"] as? String ?? "0"
        item.num_players        = data["num_players"] as? Int  ?? 0
        item.prize_amount       = data["prize_amount"] as? Float  ?? 0
        item.prize_currency     = data["prize_currency"] as? String  ?? kETHGameCurrency
        item.bet_amount         = data["bet"] as? Float  ?? KBetDefault
        item.prize_amount_fiat  = data["prize_amount_fiat"] as? Float ?? 0
        item.started_at         = convertDate(from: data["started_at"] as? String)
        item.ending_at          = convertDate(from: data["ending_at"] as? String)
        item.status             = data["status"] as? Int ?? kStatusUndefined
        item.type               = data["type"] as? Int ?? local_current_game.type
        item.gas_limit          = data["gas_limit"] as? Int ?? default_gas_limit
        item.gas_price          = data["gas_price"] as? Int ?? default_gas_price

        return item
    }

    
    static func createUserItemForGame(from data :[String : Any]) -> UserForGame{
        
        let item = UserForGame()
        
        item.user_id            = data["address"] as? String ?? "0"
        item.position           = data["position"] as? Int ?? 0
        item.prize_amount       = data["prize_amount"] as? Float ?? 0
        item.prize_amount_fiat  = data["prize_amount_fiat"] as? Float ?? 0
        
        return item
    }

    
    
    
}
