//
//  CountUppMoney.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import Splitflap


class CountUppMoney: CountDownCore  {
    
    override func initConstants(){
        
        let money2 = local_current_game.prize_amount_fiat
        
        flippersCount = 1 + Int(log10(money2)) + flippersGaps
         
    }
    
    
    override func updateLabels() -> Double{
        
        updateFlippers("\(totalCounts)")
        
        return super.updateLabels()
        
    }
    
    override func changeCounts() -> Bool {
        
        if totalCounts < startCounts {
            totalCounts += 1
            return true
        }
        
        return false
    }
 
 
}
