//
//  CountDownCore.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//
 

import UIKit
import Splitflap


class CountDownCore: UIImageView, SplitflapDelegate , SplitflapDataSource {//
    
    
    var flippersCount = 5
    
    var flippersGaps  = 3

    var timerUpdateDuration = 1.0
    
    var startCounts = 0
    
    var totalCounts = 0
    
    
    
    
    
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
    
    
    func changeFlip(_ forPlace: Int, _ labelNewText: String) {
//        
//        if let flip = viewWithTag((forPlace + 1 ) * 10000) as? FlippingLabel {
//            flip.updateWithText( labelNewText )
//
//        }
        
        if let flip = viewWithTag((forPlace + 1 ) * 10000) as? Splitflap {
            flip.setText(labelNewText, animated: true)
            
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
                                               selector: #selector(CountDownLabel.doUpdate),
                                               userInfo: nil,
                                               repeats: true)

    }
    
    
    func initTimer(_ from : Int, _ all : Int){
        
        startCounts = all
        totalCounts = from
        
//        doScheduledTimer()
        
    }
    
    
    func endTimer() {
        
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
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
//            builder.backgroundColor = UIColor(red: 251/255, green: 249/255, blue: 243/255, alpha: 1)
            builder.cornerRadius    = 5
//            builder.font            = UIFont(name: "Avenir-Black", size:45)
            builder.textAlignment   = .center
            builder.textColor       = UIColor.white
            builder.lineColor       = UIColor.black//(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
    }
}
