//
//  CountDownLabel.swift
//  Unilot
//
//  Created by Alyona on 10/11/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


protocol CountDownTimeDelegate {
    func countDownDidFall(from: Int, left: Int)
    func countDownFinished()
    
}

class CountDownLabel: UIImageView  {
    
    var labelMain = UILabel()
    
    var delegate : CountDownTimeDelegate?
    
    var startCounts = 0
    
    var totalCounts = 0
    
    var timerUpdateDuration = 1.0

    var countdownTimer: Timer!
    
    var isFull = false
    
    // MARK: - override
    
    
    func updateLabels() {
        
        let units = labelFormatted(totalCounts)
        
        updateFlippers(units)
        
    }
    
    func changeCounts()  -> Bool {
        
        if totalCounts != 0 {
            
            totalCounts -= 1
            return true
        }
        
        return false
        
    }
    
    // MARK: - inits
    
    func createBody(_ newDelegate : CountDownTimeDelegate) {
        
        if isFull {
            return
        }
        
        delegate = newDelegate
        
        createBodyTimers()
        
        updateLabels()
        
//        fixSizeOfLabel()
        
        isFull = true
    }
    
    func fixSizeOfLabel(){
        
        let fontM = labelMain.font
        labelMain.adjustsFontSizeToFitWidth = false
        labelMain.font = fontM
    }
    
    
    func createBodyTimers(){
        
        createLabelBody(self.frame.height)
        
    }
    
    func createLabelBody(_ height: CGFloat){
        
        let frameRect = CGRect(
            x: 0,
            y: 0,
            width: self.frame.width,
            height: height) 

        labelMain = UILabel(frame: frameRect)
        labelMain.backgroundColor = UIColor.clear
        labelMain.textColor = UIColor.white
        labelMain.textAlignment = .center
        labelMain.baselineAdjustment = .alignCenters
        labelMain.font = UIFont(name: kFont_Thin, size: 500)
        labelMain.adjustsFontSizeToFitWidth = true
        addSubview(labelMain)
    }
    
 
    
    //MARK: -  count down
    
    func doScheduledTimer(){
        
        endTimer()

        if doUpdate() {
            
            print("CountStart")
            
            countdownTimer  = Timer.scheduledTimer(timeInterval: timerUpdateDuration,
                                                   target: self,
                                                   selector: #selector(CountDownLabel.doUpdate),
                                                   userInfo: nil,
                                                   repeats: true)
            

        }
        
     }
    
    
    
    func initTimer(_ from : Int, _ all : Int){
        
        startCounts = all
        totalCounts = from 
        
    }
    
    
    func endTimer() {
         
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }
    
    
    func updateFlippers(_ newText : String) {
        
        labelMain.text = newText
    }
    
    func labelFormatted(_ totalUnits: Int) -> String {
        
        return String(format:"%02i", totalUnits)
    }
    
    
   @objc func doUpdate() -> Bool{
        
        if changeCounts() {
        
            updateLabels()

            delegate?.countDownDidFall(from: startCounts, left: totalCounts)
        
            return true
            
        } else {
            
            endTimer()
            
            delegate?.countDownFinished()
            
            return false
        }
    }
    
    
    
}

