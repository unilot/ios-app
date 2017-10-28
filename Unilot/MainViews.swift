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
    
    
    func waitForNewGame(){
        titleUntilTheEnd.text = TR("Система выбирает победителя")

    }
    
    override func setGameNumbers(){
        
        local_current_game = games_list[kTypeDay]!
 
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
    
//    override func addSwipeForMenuOpen(){
//        
//        if revealViewController() != nil {
//            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
//        }
//    }
}


class MainWeekView: MainView {
    
    override func setGameNumbers(){
        
        local_current_game = games_list[kTypeWeek]!
        
    }
    
//    override func addSwipeForMenuOpen(){
//        
//        if revealViewController() != nil {
//            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
//        }
//    }
    
}


