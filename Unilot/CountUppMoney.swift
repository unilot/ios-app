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


class CountDownTimeMonth: CountDownCore  {
    
    override func initConstants(){
        
        flippersCount = 2
        
        flippersGaps  = 3
        
        timerUpdateDuration = 6.0 // tmp
        
    }
    
    
    override func updateLabels() {
        
        updateFlippers("\(totalCounts)")
        
    }
    
    override func changeCounts() -> Bool {
        
        if totalCounts > 0 {
            
            totalCounts -= 1
            return true
        }
        
        return false
    }
    
    
    override  func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
        return FlapViewBuilder { builder in
            
            let uiImage   = imageScaledToSize(size: splitflap.frame.size, image:  UIImage(named:"fullWhiteFlipper")!)
            
            builder.backgroundColor = UIColor(patternImage: uiImage)
            builder.cornerRadius    = 5
            builder.textAlignment   = .center
            builder.textColor       = UIColor.black
            builder.font            = UIFont(name: kFont_Light, size: 80)
            builder.lineColor       = UIColor.black
        }
    }
    
}
