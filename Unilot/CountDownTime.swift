//
//  CountDownTime.swift
//  Unilot
//
//  Created by Alyona on 9/21/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


class CountDownTime: CountDownCore  {
 
    override func initConstants(){
        
         flippersCount = 6
        
         flippersGaps  = 2
        
        timerUpdateDuration = 1.0

    }
    
    
    override func updateLabels() {
        
        updateFlippers(timeFormatted(totalCounts))
        
    }
    
    override func changeCounts() -> Bool{
        
        if totalCounts != 0 {

            totalCounts -= 1
            return true
        }
        
        return false
    }
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        
        return String(format:"%02i%02i%02i", hours, minutes, seconds)
    }
 

}
