//
//  MainView.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class MainView: MainViewPositions {
  
    @IBOutlet weak var clockTablet: CountDownFullTimer!

    override func fillWithData(){
        
        if tabBarItem.tag == 0 {
            titleMain.text = "Дневная лотерея"
        } else {
            titleMain.text = "Недельная лотерея"
        }
        
        titlePrize.text = "Призовой фонд"

        titleUntilTheEnd.text = "До конца регистрации"
        
        prizePlaces.setTitle("Призовые места", for: .normal)
        
        
        setTakePartView()
        
        addTimersBody()

        answerOnInitData()
        
    }
    
    
    func answerOnInitData(){
        
        peopleCount.text = Int(2442345).stringWithSepator
        usSum.text = "$ " + Int(232345).stringWithSepator
        
        takePartEth.text = "0,0005 Eth"
        
        moneyTablet.initTimer(0, 300)
        
        clockTablet.initTimer(1500, 2500)
    }
    
    //MARK: - timers
    
   override  func addTimersBody(){
        
        moneyTablet.createBody()
        
        clockTablet.createBody(self)
    }
    
    override func startSchedule(){
        
        moneyTablet.doScheduledTimer()
        
        clockTablet.doScheduledTimer()
        print(clockTablet.frame.height , " = startSchedule heighht")

    }
    
    
    override func setMenuButton(){
        
        if revealViewController() != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
}


class MainWeekView: MainView {
    
    override func setMenuButton(){

    }
    
}

class BonusView: MainViewPositions {

    
    @IBOutlet weak var clockTablet: CountDownLabel!

    @IBOutlet weak var howDoesItWork: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    
    override func setLoadingSign(toWidth: CGFloat ){
 
    }
    
    override func countDownDidFall(from: Int, left: Int){
        
    }
    
    override func fillWithData(){
        
        titleMain.text = "Бонусная лотерея"
        
        titlePrize.text = "Призовой фонд"
        
        label1.text = "До обьявления\nпобедителей:"
        label2.text = "дней"
        
        howDoesItWork.setTitle("Как попасть в розыгрыш?", for: .normal)
        prizePlaces.setTitle("Призовые места", for: .normal)
 
        
        addTimersBody()
        
        answerOnInitData()
        
    }
    
    
    func answerOnInitData(){
        
        peopleCount.text = Int(2442345).stringWithSepator
        usSum.text = "$ " + Int(232345).stringWithSepator
        
        
        moneyTablet.initTimer(0, 300)
        
        clockTablet.initTimer(30, 0)

        clockTablet.backgroundColor = UIColor.clear
    }
    
    
    
    
    override  func setButtonView(){
        super.setButtonView()
        
        howDoesItWork.layer.borderWidth = 0.5
        howDoesItWork.layer.borderColor = UIColor.gray.cgColor
        howDoesItWork.layer.cornerRadius = howDoesItWork.frame.height/2
        howDoesItWork.backgroundColor = UIColor.clear
        
    }
    
    
    //MARK: - timers
    
    override  func addTimersBody(){
        
        moneyTablet.createBody()
        
        clockTablet.createBody(self)
        
        clockTablet.labelMain.textColor = UIColor.white
    }
    
    
    override func startSchedule(){
        
        moneyTablet.doScheduledTimer()
        
        clockTablet.doScheduledTimer()
        
    }
}


