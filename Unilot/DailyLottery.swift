//
//  DailyLottery.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class DailyLottery : MainItemView {
    
    @IBOutlet weak var viewWithEnterGame: UIView!
    @IBOutlet weak var viewWithPlayingGame: UIView!
    @IBOutlet weak var labelOnPlaying: UILabel!
    @IBOutlet weak var takePartRound: UIButton!

    override func fillWithData(){
        
        titleUntilTheEnd.text = TR("left_till_end:")
        
        takePart.setTitle(TR("participate"), for: .normal)
        
        setTakePartView()
        
        addTimersBody()
        
     }
    
    func redrawUserParticipationButtons(){
        
        if isUserInGame(current_game.game_id){
            viewWithPlayingGame.isHidden = false
            viewWithEnterGame.isHidden = true
            labelOnPlaying.text = TR("you_allready_in")
            takePartRound.layer.cornerRadius = takePartRound.frame.width/2
            
        } else {
            viewWithPlayingGame.isHidden = true
            viewWithEnterGame.isHidden = false
        }
    }
    
    
    //MARK: - timers
    
    override  func addTimersBody(){
        
        super.addTimersBody()
        
        clockTablet?.createBody(self)
        
    }
    
    override func startTimersOnFirstView(){
        
        moneyTablet.doScheduledTimer()
        
        clockTablet?.doScheduledTimer()
        
        redrawUserParticipationButtons()
    }
    
    
    override func stopAllSchedule() {
        
        moneyTablet.endTimer()
        
        clockTablet?.endTimer()
        
        secondTimerThin?.endTimer()
        
    }
    
    override func fillWithGameNumbers(){
        
        super.fillWithGameNumbers() 
        
        takePartEth.text = "\(current_game.bet_amount) Eth"

    }
}




