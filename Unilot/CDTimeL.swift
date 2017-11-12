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
 
    func setTextColor(_ color : UIColor){
        
        labelMain.textColor = color
        
        if let item = viewWithTag(200) as? UILabel{
            item.textColor = color
        }
        if let item = viewWithTag(300) as? UILabel{
            item.textColor = color
        }
        if let item = viewWithTag(400) as? UILabel{
            item.textColor = color
        }
    }
    
    func createTextStatic(_ height: CGFloat){
        
        let widthShift = self.frame.width / 3 
        
        var frameRect = CGRect(
            x: 0 ,
            y: self.frame.height - height,
            width: widthShift,
            height: height)
        
        createOneLabelStatic(frame: frameRect,200)

        frameRect.origin.x = widthShift
        createOneLabelStatic(frame: frameRect,300)

        frameRect.origin.x = widthShift * 2
        createOneLabelStatic(frame: frameRect,400)
    }
    
    
    func changeTextOnStaticLabels(_ type: Int){

        timerUpdateDuration = Double(staticClockSecondsStep[type])
        
        let names = staticClockNames[type]
        
        if let item = viewWithTag(200) as? UILabel{
            item.text = TR(names[0]) + "    "
        }
        if let item = viewWithTag(300) as? UILabel{
            item.text = TR(names[1])
        }
        if let item = viewWithTag(400) as? UILabel{
            item.text = "    " + TR(names[2])
        }
    }
 
 
    func createOneLabelStatic(frame: CGRect, _ tag : Int){
        
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: kFont_Light, size: frame.height * 0.8)
        label.clipsToBounds = false
        label.tag = tag
        label.text = kEmpty
        
        addSubview(label)
        
    }
    
    override func changeCounts()  -> Bool {
        
        if totalCounts > Int(timerUpdateDuration) {
            
            totalCounts = totalCounts - Int(timerUpdateDuration)
            return true
        }
        
        return false
        
    }
    
    override func labelFormatted(_ totalUnits: Int) -> String {
        
        if local_current_game.type == kTypeDay {
            
           return  dayParseTime(totalUnits)
        
        } else {
        
           return  usuallParseTime(totalUnits)
        
        }
    }
    
    
    func usuallParseTime(_ totalUnits: Int) -> String {
        
        if timerUpdateDuration == 1 {
            let hours = Int(totalUnits) / 3600
            let minutes = Int(totalUnits) / 60 % 60
            let seconds = Int(totalUnits) % 60
            
            return String(format:"%02i : %02i : %02i ", hours, minutes, seconds)
        }
        
        if timerUpdateDuration == 60 {
            let days = Int(totalUnits) / (3600 * 24)
            let hours = Int(totalUnits) / 3600 % 24
            let minutes = Int(totalUnits) / 60 % 60
            
            return String(format:"%02i : %02i : %02i ", days, hours, minutes)
        }
        
        if timerUpdateDuration == (3600) {
            let weeks = Int(totalUnits) / (3600 * 24 * 7)
            let days = Int(totalUnits) / (3600 * 24) / 7
            let hours = Int(totalUnits) / 3600 % 24
            
            return String(format:"%02i : %02i : %02i ", weeks, days, hours )
        }
        
        return kEmpty
    }
    
    func dayParseTime(_ totalUnits: Int) -> String {
        
        let hours = Int(totalUnits) / 3600
        let minutes = Int(totalUnits) / 60 % 60
        let seconds = Int(totalUnits) % 60
        
        return String(format:"%02i : %02i : %02i ", hours, minutes, seconds)
        
    }
    
}




class CDTimerPopUp: CountDownFullTimer  {
    
    override func createBodyTimers(){
        
        createLabelBody(self.frame.height * 0.8)
        createTextStatic(self.frame.height * 0.2)
        
    }
    
    override func createTextStatic(_ height: CGFloat){
        
        let widthShift = self.frame.width / 3
        
        var frameRect = CGRect(
            x: 0 ,
            y: self.frame.height - height*3,
            width: widthShift,
            height: height)
        
        createOneLabelStatic(frame: frameRect,200)
        
        frameRect.origin.x = widthShift
        createOneLabelStatic(frame: frameRect,300)
        
        frameRect.origin.x = widthShift * 2
        createOneLabelStatic(frame: frameRect,400)
    }
    
    
}
 

