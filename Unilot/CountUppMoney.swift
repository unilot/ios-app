//
//  CountUppMoney.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class CountUppMoney: CountDownCore  {
    
    override func initConstants(){
        
        flippersCount = 5
        
        flippersGaps  = 3
                
        timerUpdateDuration = 2.0

    }
    
    
    override func updateLabels() {
        
        updateFlippers("\(totalCounts)")
        
    }
    
    override func changeCounts() -> Bool {
        
        if totalCounts < startCounts {
            
            totalCounts += 1
            return true
        }
        
        return false
    }
 
 
}
