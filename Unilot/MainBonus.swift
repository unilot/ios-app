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
     
  
    override func fillWithData(){
                
        widthProgress = 0
        
        label1.text = TR("До объявления\nпобедителей:")
        label2.text = TR("дней")
        
        howDoesItWork.setTitle(TR("Как попасть в розыгрыш?"), for: .normal)
        
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

    override func setLoadingSign(toWidth: CGFloat ){
        
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


