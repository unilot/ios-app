//
//  MainBonus.swift
//  Unilot
//
//  Created by Alyona on 10/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

//
//  MainView.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class BonusView: MainViewPositions {
    
    
    @IBOutlet weak var daysCount : CountDownTimeMonth!
    
    @IBOutlet weak var howDoesItWork: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    
    override func setLoadingSign(toWidth: CGFloat ){
        
    }
    
    override func countDownDidFall(from: Int, left: Int){
        
    }
    
    
    override func setGameNumbers(){
        
        local_current_game = games_list[kTypeMonth]!
        
    }
    override func fillWithData(){
        
        widthProgress = 0
        
        titleMain.text = TR("Бонусная лотерея")
        
        titlePrize.text = TR("Джекпот")
        
        label1.text = TR("До обьявления\nпобедителей:")
        label2.text = TR("дней")
        
        howDoesItWork.setTitle(TR("Как попасть в розыгрыш?"), for: .normal)
        prizePlaces.setTitle(TR("Призовые места"), for: .normal)

        
        addTimersBody()
        
        answerOnInitData()
        
    } 
    
    override func setTimersNumbers(_ from: Int, _ all: Int , _ type: Int) {

        daysCount.initTimer(from/(3600*24),all/(3600*24))
    
    }
    
    override  func setButtonView(){
        
        super.setButtonView()
        
        howDoesItWork.layer.cornerRadius = howDoesItWork.frame.height/2
        howDoesItWork.backgroundColor = UIColor.clear
        
    }
    
    
    //MARK: - timers
    
    override  func addTimersBody(){
        
        moneyTablet.createBody()
        
        daysCount.createBody()
        
    }
    
    
    override func startSchedule(){
        
        moneyTablet.doScheduledTimer()
        
        daysCount.doScheduledTimer()
        
    }
    
    
    override func stopSchedule() {
        
        moneyTablet.endTimer()
        
        daysCount.endTimer()
    }
    
}


