//
//  CountDownSimpleTime.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//
 

import UIKit



class CountDownFullTimer: CountDownLabel  {
      
    
    // MARK: - inits
    
    override func createBodyTimers(){
        
        createLabelBody(self.frame.height * 0.8)
        createTextStatic(self.frame.height * 0.2)

    }
 
    
    func createTextStatic(_ height: CGFloat){
        
        let frameRect = CGRect(
            x: 0.0,
            y:  self.frame.height  -  height,
            width: self.frame.width,
            height: height )
        
        
        let label = UILabel(frame: frameRect)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = UIFont(name: kFont_Regular, size: 500)
        label.tag = 200
        label.adjustsFontSizeToFitWidth = true
        label.text = "Часа                 Минут                 Сек"
        addSubview(label)
    }
 
    
    override func labelFormatted(_ totalUnits: Int) -> String {
        
        let hours = Int(totalUnits) / 3600
        let minutes = Int(totalUnits) / 60 % 60
        let seconds = Int(totalUnits) % 60
        
        return String(format:"%02i : %02i : %02i", hours, minutes, seconds)
    }
    
    
}



class CountDownSimpleTime: CountDownFullTimer  {
    
    override func createBodyTimers(){
        
        createLabelBody(self.frame.height)
        
    }
    
}

