//
//  MainView.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class MainView: MainViewPositions {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        game_type = kTypeDay

    }
  
    override func fillWithData(){

        if tabBarItem.tag == 0 {
            titleMain.text = TR("Дневная лотерея")
        } else {
            titleMain.text = TR("Недельная лотерея")
        }
        
        titlePrize.text = TR("Джекпот")

        titleUntilTheEnd.text = TR("До конца регистрации")
        
        prizePlaces.setTitle(TR("Призовые места"), for: .normal)
         
        setTakePartView()
        
        addTimersBody() 

        
    }
    
    
    //MARK: - timers
    
   override  func addTimersBody(){
        
        moneyTablet.createBody()
        
        clockTablet?.createBody(self)
    
    }
    
    override func startSchedule(){
        
        if firstOverlay.isHidden{
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        game_type = kTypeWeek

    }
    
}


