//
//  MainView.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit

class MainView: MainViewPositions {
  
    
    override func fillWithData(){
        
        titlePrize.text = "Призовой фонд"

        peopleCount.text = Int(2442345).stringWithSepator
        usSum.text = Int(232345).stringWithSepator
        
        
        titleUntilTheEnd.text = "До конца регистрации"
        
        
        prizePlaces.setTitle("Призовые места", for: .normal)
        takePartEth.text = "0,0005 Eth"
        
        
        NetWork.getTimeCountInfo()
        
        moneyTablet.initTimer(0, 300)
        
        clockTablet.initTimer(1500, 2500)
        
    }
    
     
 
}


