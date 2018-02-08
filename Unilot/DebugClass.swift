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
    
    
    static func changeStatusOfGame(){
        
//        Debug.changeStatusOfGame(gameInd: kTypeWeek, status: kStatusFinishing)
//
//        Debug.changeStatusOfGame(gameInd: kTypeToken, status: kStatusFinishing)
 
        
    }
    
    
    static func addPushNotificationToCurrentGame(_ lotteryItem : LotteryItemsView){
        
//        Debug.addWinPush(lotteryItem)
//
//        Debug.addLostPush(lotteryItem)
        
    }
    
    static func changeStatusOfGame(gameInd : Int, status : Int){

        games_list[gameInd]?.status = status
        
    }
 

    
    static func addWinPush(_ lotteryItem : LotteryItemsView){
        
        let user = UserForGame()
        user.position = 0
        user.user_id = users_account_number[0]
        user.prize_currency = "ETH"
        user.prize_amount_fiat = 98.789
        user.prize_amount = 0.04
        lotteryItem.showYouWin(user)
    }
    
    
    static func addLostPush(_ lotteryItem : LotteryItemsView){
         lotteryItem.showYouLost()
    }}

