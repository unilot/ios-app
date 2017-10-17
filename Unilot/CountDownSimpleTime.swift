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
        
        createLabelBody(self.frame.height)
        createTextStatic(self.frame.height * 0.2)

    }
 
    
    func createTextStatic(_ height: CGFloat){
        
        let widthShift = self.frame.width / 3 
        
        var frameRect = CGRect(
            x: 0 ,
            y: self.frame.height - height,
            width: widthShift,
            height: height)
        
        createOneLabelStatic(frame: frameRect,
                             text: TR("Часа  "),200)

        frameRect.origin.x = widthShift
        createOneLabelStatic(frame: frameRect,
                             text: TR("Минут"),300)

        frameRect.origin.x = widthShift * 2
        createOneLabelStatic(frame: frameRect,
                             text: TR("  Сек"),400)
    }
    
 
 
    func createOneLabelStatic(frame: CGRect, text : String,_ tag : Int){
        
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: kFont_Light, size: frame.height * 0.8)
        label.clipsToBounds = false
        label.tag = tag
        label.text = text
        
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

