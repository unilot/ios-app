//
//  BonusLottery.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class BonusLottery: MainItemView {
     
    @IBOutlet weak var daysCount : CountDownTimeMonth!
    
    @IBOutlet weak var howDoesItWork: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    
    override func fillWithData(){
        
        widthProgress = 0
        
        label1.text = TR("left_\nbefore_end")
        label2.text = TR("days2")
        
        howDoesItWork.setTitle(TR("how_join?"), for: .normal)
        
        addTimersBody()
        
    }
    
    override func setTimersNumbers(_ from: Int, _ all: Int , _ type: Int) {
        
        daysCount.initTimer(from/(3600*24),all/(3600*24))
        
    }
    
    override  func setButtonView(){
        
        super.setButtonView()
        
        howDoesItWork.layer.cornerRadius = howDoesItWork.frame.height/2
        howDoesItWork.backgroundColor = UIColor.clear
        
    }
    
    //MARK: - CountDownTimeDelegate
    
     
    override func onEthButton(){
        
        playStandart()
        
        sendServerCheckForUpdateData()
        
        sendEvent("EVENT_BONUS_PARTICIPATE_REFRESH")
    }
    
    //MARK: - timers
    
    override  func addTimersBody(){
        
        super.addTimersBody()
        
        daysCount.initConstants(0)
        daysCount.createBody()
        
    }
    
    override func startTimersOnFirstView(){
        
        moneyTablet.doScheduledTimer()
        
        daysCount.doScheduledTimer()
        
    }
    
    override func stopAllSchedule() {
        
        moneyTablet.endTimer()
        
        daysCount.endTimer()
        
        secondTimerThin?.endTimer()
        
    }
    

    
}


