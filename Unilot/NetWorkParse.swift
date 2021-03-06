//
//  NetWorkParse.swift
//  Unilot
//
//  Created by Alyona on 10/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import Foundation
//import Firebase
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
        
        Debug.changeStatusOfGame()

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
    
    static func parseMyWalletsDetails(_ resultValue : Any) -> String?{

        guard let responseJSON = resultValue as? [Any] else {
            return message_to_Crashlytics(line: "MyWalletsDetails")
        }
 
        for item in responseJSON {
           
            if let games_data = item as? [String:Any] {
                createWallet(games_data)
            }
            
        }
        
        return nil
        
    }
    

    
    //MARK: - fill items
    
    static func createGameItem(from data :[String : Any] ) -> GameInfo{
            
        let item = GameInfo()
       
        item.game_id            = "\(data["id"] ?? kEmpty )"
        item.smart_contract_id  = data["smart_contract_id"] as? String ?? "0"
        item.num_players        = data["num_players"] as? Int  ?? 0
        item.prize_amount_fiat  = data["prize_amount_fiat"] as? Float ?? 0
        item.started_at         = convertDate(from: data["started_at"] as? String)
        item.ending_at          = convertDate(from: data["ending_at"] as? String)
        item.status             = data["status"] as? Int ?? kStatusUndefined
        item.type               = data["type"] as? Int ?? local_current_game.type
        item.gas_limit          = data["gas_limit"] as? Int ?? default_gas_limit
        item.gas_price          = data["gas_price"] as? Int ?? default_gas_price

        if let prize = data["prize_amount"] as? [String : Any] {
            
            item.prize_amount       = prize["amount"] as? Float  ?? 0
            item.prize_currency     = prize["currency"] as? String  ?? kETHGameCurrency

        }
        
        if let bet = data["bet_amount"] as? [String : Any] {
            
            item.bet_amount         = bet["amount"] as? Float  ?? KBetDefault

        }
        

        return item
    }

    
    static func createUserItemForGame(from data :[String : Any]) -> UserForGame{
        
        let item = UserForGame()
        
        item.user_id            = data["address"] as? String ?? "0"
        item.position           = data["position"] as? Int ?? -1
        item.prize_amount_fiat  = data["prize_amount_fiat"] as? Float ?? 0
        
        if let prize = data["prize_amount"] as? [String : Any] {
            
            item.prize_amount       = prize["amount"] as? Float  ?? 0
            item.prize_currency     = prize["currency"] as? String  ?? kETHGameCurrency
            
        }
        
        return item
    }
 
    static func createWallet(_ games_data : [String:Any]){
        
        let wallet = Wallet()
        
        if let wallet_name = games_data["wallet"] as? String {
            
            wallet.smart_contract_id = wallet_name
            
            if let games_array = games_data["games"] as? [Int] {
                wallet.active_games = games_array.map { "\($0)" }
                
                
                if let ind = users_account_wallets.index(where: { $0.smart_contract_id == wallet_name}) {
                    users_account_wallets[ind].active_games = wallet.active_games
                } else {
                    users_account_wallets.append(wallet)
                }
            }
        }
    }
    
}
