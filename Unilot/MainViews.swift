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

        titleUntilTheEnd.text = TR("До конца регистрации")
        
        prizePlaces.setTitle(TR("Призовые места"), for: .normal)
        
        takePart.setTitle(TR("Принять участие"), for: .normal)
        
        setTakePartView()
        
        addTimersBody() 

        
    }
    
    
    //MARK: - timers
    
   override  func addTimersBody(){
    
        super.addTimersBody()
        
        clockTablet?.createBody(self)
    
    }
    
    override func startSchedule(){
        
        if secondTimerThin != nil {
            secondTimerThin?.doScheduledTimer()
        } else {
            moneyTablet.doScheduledTimer()
            
            clockTablet?.doScheduledTimer()
        }
    }
    
    override func stopSchedule() {
        
        moneyTablet.endTimer()
        
        clockTablet?.endTimer()
        
        secondTimerThin?.endTimer()

    }
    
    
}


class MainWeekView: MainView {
    

    
}


