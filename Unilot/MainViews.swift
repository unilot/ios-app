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
        
        if tabBarItem.tag == 0 {
            titleMain.text = "Дневная лотерея"
        } else {
            titleMain.text = "Недельная лотерея"
        }
        
        titlePrize.text = "Джекпот"

        titleUntilTheEnd.text = "До конца регистрации"
        
        prizePlaces.setTitle("Призовые места", for: .normal)
         
        setTakePartView()
        
        addTimersBody()
        
        setGameNumbers()
        
        answerOnInitData()

    }
    
    
    func setGameNumbers(){
        
        local_current_game_type = kTypeDay
        
    }
    
    //MARK: - timers
    
   override  func addTimersBody(){
        
        moneyTablet.createBody()
        
        clockTablet?.createBody(self)
    }
    
    override func startSchedule(){
        
        moneyTablet.doScheduledTimer()
        
        clockTablet?.doScheduledTimer()

    }
    
    override func stopSchedule() {
        
        moneyTablet.endTimer()
        
        clockTablet?.endTimer()
    }
    
    override func addSwipeForMenuOpen(){
        
        if revealViewController() != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
}


class MainWeekView: MainView {
    
    override func setGameNumbers(){
        
        local_current_game_type = kTypeWeek
        
    }
    
    override func addSwipeForMenuOpen(){

    }
    
}


