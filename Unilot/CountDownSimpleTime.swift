//
//  CountDownSimpleTime.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//
 

import UIKit

protocol CountDownTimeDelegate {
    func countDownDidFall(_ tag: Int, from: Int, left: Int)
    func countDownFinished(_ tag: Int)
    
}

class CountDownSimpleTime: UIImageView  {
    
    
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
    
    func createBody() -> Bool {
        
        if isFull {
            return false
        }
        
        createLabelBody()
        
        createTextStatic()
        
        updateLabels()

        isFull = true
        
        return isFull
    }
    
    
    func createLabelBody(){
        
        let frameRect = CGRect(
            x: 0.0,
            y: 0,
            width: self.frame.width,
            height: self.frame.height * 0.8)
        
        
        let label = UILabel(frame: frameRect)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-light", size: 50)
        label.tag = 100
        addSubview(label)
    }
    
    
    func createTextStatic(){
        
        let frameRect = CGRect(
            x: 0.0,
            y:  self.frame.height * 0.8,
            width: self.frame.width,
            height: self.frame.height * 0.2)
        
        
        let label = UILabel(frame: frameRect)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = UIFont(name: "Helvetica", size: 12)
        label.tag = 200
        label.text = "Часа                 Минут                 Сек"
        addSubview(label)
    }
    
    
    //MARK: -  count down
    
    func startTimer(_ from : Int, _ all : Int){
        
        startCounts = all
        totalCounts = from
        
        countdownTimer  = Timer.scheduledTimer(timeInterval: 1.0,
                                               target: self,
                                               selector: #selector(CountDownTime.doUpdate),
                                               userInfo: nil,
                                               repeats: true)
        
    }
    
    
    func endTimer() {
        
        countdownTimer.invalidate()
        
    }
 
    
    func updateFlippers(_ newText : String) {
        
        let label = viewWithTag(100) as! UILabel
        label.text = newText

        
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
            delegate?.countDownDidFall(self.tag, from: startCounts, left: totalCounts)
        } else {
            endTimer()
            delegate?.countDownFinished(self.tag)
        }
    }
    
    
    
}

