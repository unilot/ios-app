//
//  CountDownTablet.swift
//  Unilot
//
//  Created by Alyona on 9/21/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

protocol CountDownTabletDelegate {
    func countDownDidFall(from: Int, left: Int)
    func countDownFinished()
    
}

class CountDownTablet: UIImageView  {
    
 
    var delegate : CountDownTabletDelegate?
    
    var flippersCount = 6
    
    let distanceFromFlipps = 4.0
    
    var countdownTimer: Timer!

    var startTime = 1500

    var totalTime = 1500
    
    var isFull = false
    
    func createBody() -> Bool {
        
        if isFull {
            return false
        }
        
        for i in 0..<flippersCount {
            createFlipWithLabel(i)
        }
        
        isFull = true
        
        return isFull
    }

    // MARK: - inits
    
    func createFlipWithLabel(_ atPlace: Int ){
        
        let smallShift = getSmallShift(flippersCount)
        let shiftForCurrentFip = (flippersCount - atPlace) / 3
        let widthOfFlip = (frame.width) / CGFloat(flippersCount)
        
        let frameRect = CGRect(
            x: widthOfFlip * CGFloat(flippersCount - atPlace - 1) + CGFloat( shiftForCurrentFip)  * smallShift,
//            x:( widthOfFlip + CGFloat(distanceFromFlipps)) * CGFloat(flippersCount - atPlace),
            y: 0,
            width: widthOfFlip - CGFloat( distanceFromFlipps),
            height: self.frame.height)
        
        let flip = FlippingView()
        flip.initViewWithLabel(frameRect)
        flip.tag = atPlace * 1000
        addSubview(flip)
        
    }
    
   
    
    func getSmallShift(_ fromCount : Int) -> CGFloat {
        
        return CGFloat( (flippersCount - fromCount) / 3 ) * CGFloat(distanceFromFlipps)
        
    }
    
    //MARK: -  count down
    func startTimer(_ timer : Int){
        
        startTime = timer
        totalTime = timer
        
        countdownTimer  = Timer.scheduledTimer(timeInterval: 1.0,
                                      target: self,
                                      selector: #selector(CountDownTablet.doUpdate),
                                      userInfo: nil,
                                      repeats: true)

    }

    
    func endTimer() {
        
        countdownTimer.invalidate()
    
    }
    
    
    func doUpdate(){
        
        updateLabels()

        if totalTime != 0 {
            totalTime -= 1
            delegate?.countDownDidFall(from: startTime, left: totalTime)
        } else {
            endTimer()
            delegate?.countDownFinished()
        }
    }
    
    func updateLabels() {
        
        let units = timeFormatted(totalTime)
        
        changeDigit(forPlace: 0,  units)
        changeDigit(forPlace: 1,  units)
        
        changeDigit(forPlace: 2,  units)
        changeDigit(forPlace: 3,  units)
        
        changeDigit(forPlace: 4,  units)
        changeDigit(forPlace: 5,   units)
        
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        
        return String(format:"%02i%02i%02i", hours, minutes, seconds)
    }
     
    func changeDigit(forPlace: Int, _ units: String) {
 
        let flip = viewWithTag(forPlace * 1000) as! FlippingView
        let ind = units.characters.index(units.characters.startIndex, offsetBy: ( units.characters.count - forPlace - 1))
        flip.updateWithText( String(units[ind]) )
 
    }
    
    
}
