//
//  CountDownCore.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//
 

import UIKit
import Splitflap


protocol CountUppFlippersMoneyDelegate {
    func countUppMoneyFinished(_ currentTime : Int )
}

class CountDownCore: UIImageView, SplitflapDelegate , SplitflapDataSource {//
    
    
    var delegate : CountUppFlippersMoneyDelegate?

    
    var stepCount = 1

    var rotation_speed = 0.05
    
    var comaPlace = Float(1.55)

    var flippersCount = 6
    
    var flippersGaps  = 3

    

    
    var timerStep = 0.0

    var timerCoeff  = 0.0

    var timerPrevious  = 0.0
    
    
    
    var startCounts = 0
    
    var totalCounts = 0
    
    
    
    
    
    var countdownTimer: Timer!
    
    var isFull = false
    
    

    
    // MARK: - override

    func initConstants(_ type : Int){
        

    }
    
    
    func updateLabels() -> Double{        
        
        let newTimerPrevious =  timerStep * timerStep
        
        let delay = (newTimerPrevious - timerPrevious)  * timerCoeff
        
        timerPrevious = newTimerPrevious
        
        timerStep = timerStep + 1
        
        rotation_speed = min(delay, 0.15)
        
        return rotation_speed
        
    }
    
    func changeCounts()  -> Bool {
        //          totalCounts -= 1
        
        return false
    }
    
    // MARK: - inits
    
    func createFlipWithLabel(_ atPlace: Int ){
        
        let distanceFromFlipps = CGFloat(2.0)
        let shiftForCurrentFip = atPlace / flippersGaps
        let widthOfFlip = (frame.width) / CGFloat(flippersCount)
        let comaWidth = widthOfFlip/3
        
        
        
        let frameRect = CGRect(
            x: widthOfFlip * CGFloat(flippersCount - atPlace - 1) - CGFloat( shiftForCurrentFip)  * comaWidth,
            y: 0,
            width: widthOfFlip -  distanceFromFlipps,
            height: self.frame.height)
        
        //        let uiImage   = imageScaledToSize(size: frameRect.size, image:  UIImage(named:"flipFull")!)
        
        let splitflapView = Splitflap(frame: frameRect)
        splitflapView.datasource = self
        splitflapView.delegate   = self
        splitflapView.tag =  (atPlace + 1 ) * 10000
        addSubview(splitflapView)

        
//        let flip = FlippingLabel()
//        flip.text = "0"
//        flip.tag = (atPlace + 1 ) * 10000
//        flip.initViewWithLabel(frameRect, uiImage)
//        addSubview(flip)
        
    }

    
    func adComa(){
       
        let widthOfFlipper = frame.width / CGFloat(flippersCount)
        
        let frameComa = CGRect(x: widthOfFlipper * CGFloat(flippersCount - flippersGaps) - widthOfFlipper / 3,
                               y: 0,
                      width: widthOfFlipper / 3 ,
                      height: frame.height)
        
        let labelMain = UILabel(frame: frameComa)
        labelMain.textColor = kColorLightOrange
        labelMain.text = ","
        labelMain.backgroundColor = UIColor.clear
        labelMain.textAlignment = .center
        labelMain.baselineAdjustment = .alignBaselines
        labelMain.font = UIFont(name: kFont_Light, size: 70)
        labelMain.adjustsFontSizeToFitWidth = true
        addSubview(labelMain)
    }
    
    
    
    
    func changeFlip(_ forPlace: Int, _ labelNewText: String, _ animated : Bool) {

        if let flip = viewWithTag((forPlace + 1 ) * 10000) as? Splitflap {
            flip.setText(labelNewText, animated: animated)
        }
        
        
    }
    
    
    func completeCountFast(){

    }
    
    func createBody(){
        
        if isFull {
            return
        }
        
        for i in 0..<flippersCount {
            createFlipWithLabel(i)
        }
        
        adComa()
         
        isFull = true
    }
    
    
    
    //MARK: -  count down
    func doScheduledTimer(){

        doUpdate()

    }
    
    
    
    
    func initTimer(_ from : Int, _ all : Int){
        
        startCounts = all
        totalCounts = max(from,totalCounts)
        
        let diff = Double(abs(all - from))
        
        if diff > 0 {
            
            timerCoeff = timeOfFlipperAnimation / (diff * diff)
            
        } else {
            
            updateFlippers("\(totalCounts)", false)
            
        } 
        
    }
    
    
    func endTimer() {
        
        if countdownTimer != nil {
            
            countdownTimer.invalidate()
            countdownTimer = nil
            
            delegate?.countUppMoneyFinished(totalCounts)
            
        }
    }

    func changeDigit(forPlace: Int, _ units: String, _ animated : Bool) {
        
        var newLabelText = "0"
        
        if forPlace < units.characters.count {
            let ind = units.characters.index(units.characters.startIndex, offsetBy: ( units.characters.count - forPlace - 1))
            newLabelText = String(units[ind])
 
        }

        changeFlip(forPlace, newLabelText, animated)
        
    }
    
    
    func updateFlippers(_ units : String,  _ animated : Bool = true) {
        
        for i in 0..<flippersCount {
            changeDigit(forPlace: i,  units, animated)
        }
        
    }
    
    func doUpdate(){
        
        let delay = updateLabels()
        
        if changeCounts() {
            
            countdownTimer  = Timer.scheduledTimer(timeInterval: delay,
                                                   target: self,
                                                   selector: #selector(CountDownCore.doUpdate),
                                                   userInfo: nil,
                                                   repeats: false)
        } else {
            endTimer()
        }
    }


    //MARK: - SplitFlap delegates
    
    
    func numberOfFlapsInSplitflap(_ splitflap: Splitflap) -> Int{
        return 1
    }

    func tokensInSplitflap(_ splitflap: Splitflap) -> [String] {
        return "0123456789".characters.map { String($0) }
    }
    
//    func splitflap(_ splitflap: Splitflap, rotationDurationForFlapAtIndex index: Int) -> Double
//
    // MARK: - Configuring the Label of Flaps
    
    /**
     Called by the split-flap when it needs to create its flap subviews.
     
     - parameter splitflap: The split-flap view requesting the data.
     - parameter index: A zero-indexed number identifying a flap. The index starts
     at 0 for the leftmost flap.
     - returns: A FlapView builder object to create custom flaps.
     */
 
    func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
        return FlapViewBuilder { builder in
            
            let uiImage   = imageScaledToSize(size: splitflap.frame.size, image:  UIImage(named:"flipFull")!)

            builder.backgroundColor = UIColor(patternImage: uiImage)
            builder.cornerRadius    = 5
            builder.textAlignment   = .center
            builder.textColor       = kColorLightOrange
            builder.font            = UIFont(name: kFont_Light, size: 60)
            builder.lineColor       = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
    }
    
    func splitflap(_ splitflap: Splitflap, rotationDurationForFlapAtIndex index: Int) -> Double {
        
        return rotation_speed
    
    }
}
