//
//  CountDownSimpleTime.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//
 

import UIKit

protocol CountDownTimeDelegate {
    func countDownDidFall(from: Int, left: Int)
    func countDownFinished()
    
}

class CountDownSimpleTime: UIImageView  {
    
    var labelMain = UILabel()
    
    var delegate : CountDownTimeDelegate?
    
    var startCounts = 1500
    
    var totalCounts = 1500

    
    
    var countdownTimer: Timer!
    
    var isFull = false
    
    
    
    
    // MARK: - override
 
    
    func updateLabels() {
        
        let units = timeFormatted(totalCounts)
        
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
    
    func createBody(_ newDelegate : CountDownTimeDelegate, _ withLabel: Bool = true) {
        
        if isFull {
            return
        }
        
        delegate = newDelegate

        if withLabel {
            createLabelBody(self.frame.height * 0.4)
            createTextStatic( self.frame.height * 0.1)
        } else {
            createLabelBody(self.frame.height)
        }

        updateLabels()

        isFull = true
    }
    
    
    func createLabelBody(_ height: CGFloat){
        
        
        let frameRect = CGRect(
            x: 0.0,
            y: 0,
            width: self.frame.width,
            height: height)
        
        
        labelMain = UILabel(frame: frameRect)
        labelMain.textColor = UIColor.white
        labelMain.textAlignment = .center
        labelMain.font = UIFont(name: "Helvetica-light", size: 50)
        labelMain.adjustsFontSizeToFitWidth = true
        addSubview(labelMain)
    }
    
    
    
    func createTextStatic(_ height: CGFloat){
        
        let frameRect = CGRect(
            x: 0.0,
            y:  self.frame.height * 0.35,
            width: self.frame.width,
            height: height )
        
        
        let label = UILabel(frame: frameRect)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = UIFont(name: "Helvetica", size: 12)
        label.tag = 200
        label.text = "Часа                 Минут                 Сек"
        addSubview(label)
    }
    
    
    //MARK: -  count down
    
    func doScheduledTimer(){
        
        countdownTimer  = Timer.scheduledTimer(timeInterval: 1.0,
                                               target: self,
                                               selector: #selector(CountDownTime.doUpdate),
                                               userInfo: nil,
                                               repeats: true)
        
    }
    
    
    
    func initTimer(_ from : Int, _ all : Int){
        
        startCounts = all
        totalCounts = from
        
//        doScheduledTimer()
        
    }
    
    
    func endTimer() {
        
        countdownTimer.invalidate()
        
    }
 
    
    func updateFlippers(_ newText : String) {
        
        labelMain.text = newText
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        
        return String(format:"%02i : %02i : %02i", hours, minutes, seconds)
    }
    
    
    func doUpdate(){
        
        updateLabels()
        
        if changeCounts() {
            delegate?.countDownDidFall(from: startCounts, left: totalCounts)
        } else {
            endTimer()
            delegate?.countDownFinished()
        }
    }
    
    
    
}

