//
//  ViewController.swift
//  FlippingLabelExample
//
//  Created by Matthias Mellouli on 2017-02-03.
//  Copyright © 2017 Matthias Mellouli. All rights reserved.
//

import UIKit

class MainView: MainViewPositions {
  
    
    override func fillWithData(){

        fillDataDay()
        
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
    
    
    func fillDataDay(){
        
//        titleMain.text = "Дневная лотерея"
        
    }

    
    func fillDataMonth(){
        
//        titleMain.text = "Месячная лотерея"
         
        
    }
 
}


