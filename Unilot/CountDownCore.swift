//
//  CountDownCore.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//
 

import UIKit


class CountDownCore: UIImageView  {
    
    
    var flippersCount = 5
    
    var flippersGaps  = 3

    var timerUpdateDuration = 1.0
    
    var startCounts = 1500
    
    var totalCounts = 1500
    
    
    
    
    
    var countdownTimer: Timer!
    
    var isFull = false
    
    

    
    // MARK: - override

    func initConstants(){
        

    }
    
    
    func updateLabels() {
        
        //        let units = timeFormatted(totalTime)
        
        //        changeDigit(forPlace: 0,  units)
        
        
    }
    
    func changeCounts()  -> Bool {
        //          totalCounts -= 1
        
        return false
    }
    
    // MARK: - inits
    
    func createFlipWithLabel(_ atPlace: Int ){
        
        let distanceFromFlipps = CGFloat(4.0)
        let shiftForCurrentFip = atPlace / flippersGaps
        let widthOfFlip = (frame.width) / CGFloat(flippersCount)
        
        let frameRect = CGRect(
            x: widthOfFlip * CGFloat(flippersCount - atPlace - 1) - CGFloat( shiftForCurrentFip)  * distanceFromFlipps,
            y: 0,
            width: widthOfFlip -  distanceFromFlipps,
            height: self.frame.height)
        
        let uiImage   = imageScaledToSize(size: frameRect.size, image:  UIImage(named:"flipFull")!)
        
        let flip = FlippingLabel()
        flip.text = "0"
        flip.tag = (atPlace + 1 ) * 10000
        flip.initViewWithLabel(frameRect, uiImage)
        addSubview(flip)
        
    }
    
    
    func changeFlip(_ forPlace: Int, _ labelNewText: String) {
        
        if let flip = viewWithTag((forPlace + 1 ) * 10000) as? FlippingLabel {
            flip.updateWithText( labelNewText )

        }
        
    }
    
    
    func createBody(){
        
        initConstants()
        
        if isFull {
            return
        }
        
        for i in 0..<flippersCount {
            createFlipWithLabel(i)
        }
        
        isFull = true
    }
    
    
    
    //MARK: -  count down
    func doScheduledTimer(){

        countdownTimer  = Timer.scheduledTimer(timeInterval: timerUpdateDuration,
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
        countdownTimer = nil
    }

    func changeDigit(forPlace: Int, _ units: String) {
        
        var newLabelText = "0"
        
        if forPlace < units.characters.count {
            let ind = units.characters.index(units.characters.startIndex, offsetBy: ( units.characters.count - forPlace - 1))
            newLabelText = String(units[ind])
 
        }

        changeFlip(forPlace, newLabelText )
        
    }
    
    
    func updateFlippers(_ units : String) {
        
        for i in 0..<flippersCount {
            changeDigit(forPlace: i,  units)
        }
        
    }
    
    func doUpdate(){
        
        updateLabels()
        
        if changeCounts() {

        } else {
            endTimer()
        }
    }


    
}
