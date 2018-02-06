//
//  CountDownTimeMonth.swift
//  Unilot
//
//  Created by Alyona on 10/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import Splitflap



class CountDownTimeMonth: CountDownCore  {
    
    override func initConstants(_ type : Int){
        
        flippersCount = 2
                
    }
    
    
    override  func adComa(_ onPlaceFromEnd : Int){

        
    }
    
    
    override func updateLabels() -> Double{
        
        updateFlippers("\(totalCounts)")
        
        return 24 * 60 * 60
    }
    
    override func changeCounts() -> Bool {
        
        if totalCounts > 0 {
            
            totalCounts -= 1
            return true
        }
        
        return false
    }
    
    
    override  func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
        return FlapViewBuilder { builder in
            
            let uiImage   = imageScaledToSize(size: splitflap.frame.size, image:  UIImage(named:"fullWhiteFlipper")!)
            
            builder.backgroundColor = UIColor(patternImage: uiImage)
            builder.cornerRadius    = 5
            builder.textAlignment   = .center
            builder.textColor       = UIColor.black
            builder.font            = UIFont(name: kFont_Light, size: 80)
            builder.lineColor       = UIColor.black
        }
    }
    
}
