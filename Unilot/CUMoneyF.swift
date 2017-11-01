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
    
    override func initConstants(_ type : Int){
        
        if let money = games_list[type]{
            
            if money.prize_amount > 0 {
                flippersCount = max(6,1 + Int(log10(money.prize_amount)) + flippersGaps)
            }

        }
        
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
 
    
    func completeFlipping(){
        
        endTimer()
        
        totalCounts =  startCounts
        
        updateFlippers("\(totalCounts)", false)
    }
 
}
