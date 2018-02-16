//
//  DebugClass.swift
//  Unilot
//
//  Created by Alyona2013 on 2/9/18.
//  Copyright © 2018 Vovasoft. All rights reserved.
//

import UIKit

let switch_off_all_debug = false
class Debug {
    
    static func putPlayerInGame() -> Bool{
        
        
        return  Debug.userInGame()
        
//        return false
    }
    
    
    static func changeStatusOfGame(){
        
//        Debug.changeDataOfGame(gameInd: kTypeWeek)

//        Debug.changeStatusOfGame(gameInd: kTypeToken, status: kStatusFinishing)
 
        
    }
    
    
    static func addPushNotificationToCurrentGame(_ lotteryItem : LotteryItemsView){
        
        Debug.addWinPush(lotteryItem)
//
//        Debug.addLostPush(lotteryItem)
        
    }
    
    
    static func onReloadButton(_ lotteryItem : LotteryItemsView){
    
//        Debug.removeGame(gameInd: kTypeWeek)
        
    }
    
    //MARK: - realization
    static func userInGame() -> Bool{
        
        return true
    }
    
    static func removeGame(gameInd : Int){
        
        games_list.removeValue(forKey: gameInd)
        
    }
    
    static func changeStatusOfGame(gameInd : Int, status : Int){

        games_list[gameInd]?.status = status
        games_list[gameInd]?.ending_at = games_list[gameInd]!.ending_at + 36000

    }
    
    static func changeDataOfGame(gameInd : Int){

        games_list[gameInd]?.prize_amount = 0.23
        games_list[gameInd]?.prize_currency = "ETH"
        games_list[gameInd]?.prize_amount_fiat = 23

    }

    
    static func addWinPush(_ lotteryItem : LotteryItemsView){
        
        let user = UserForGame()
        user.position = 0
        user.user_id = users_account_wallets.first?.smart_contract_id ?? kEmpty
        user.prize_currency = "ETH"
        user.prize_amount_fiat = 98.789
        user.prize_amount = 0.04
        lotteryItem.showYouWin(user)
    }
    
    
    static func addLostPush(_ lotteryItem : LotteryItemsView){
         lotteryItem.showYouLost()
    }}

