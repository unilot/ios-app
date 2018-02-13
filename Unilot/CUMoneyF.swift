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
    
    
    func initConstants(_ type : Int, _ delegate_core : CountUppFlippersMoneyDelegate){
        
        delegate = delegate_core
        
        if let money = games_list[type]{
            
            if money.prize_amount > 0 {
                
                var numberFF = money.prize_amount
                
                if Int(numberFF * 1000) % 1000 == 0 {
                    numberFF = numberFF / 1000
                }
                
                flippersCount = max(6,1 + Int(log10(numberFF)) + flippersGaps)
            }

        }
        
    }
    
    
    func updateLabelsToZero(){
        
        updateFlippers("0")
        
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
