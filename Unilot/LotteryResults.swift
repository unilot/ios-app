//
//  LotteryResults.swift
//  Unilot
//
//  Created by Alyona on 10/18/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//



import UIKit
import SCLAlertView



class LotteryResults: PopUpCore, CountDownTimeDelegate {

    @IBOutlet weak var clockTablet: CountDownSimpleDays!
    
    @IBOutlet weak var icoImage: UIImageView!

    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var unfortunately: UITextView!
    @IBOutlet weak var butHey: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    class func createLotteryResults() -> LotteryResults {
        let myClassNib = UINib(nibName: "LotteryResults", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! LotteryResults
    }
    
    
    
    override func setInitBorders(){
        
        super.setInitBorders()
        
        clockTablet.layoutIfNeeded()
        
        
        let type = kTypeTabBarOrder.index(of: local_current_game.type)

        titleMain.text = TR("Итоги") + " " + TR(setting_strings[0][type!])
        dayTitle.text = getNiceDateFormatString(from: local_current_game.started_at)
        unfortunately.text = TR("К сожалению, вас нет в списке победителей")
        butHey.text =  TR("Вы автоматически становитесь участником бонусного розыгрыша который состоится через:")
        endLabel.text = TR("До объявления победителя")
        days.text = TR("Дней")
        copyButton.setTitle(TR("История розыгрыша"), for: .normal)
        
        clockTablet.createBody(self)
       // clockTablet.labelMain.frame.origin = CGPoint(x: 0,
         //                                            y: -clockTablet.labelMain.frame.height * 0.35)
        
        clockTablet.labelMain.font = UIFont(name: kFont_Regular, size: 500)
        clockTablet.labelMain.adjustsFontSizeToFitWidth = true
        clockTablet.labelMain.textColor = UIColor.black
        clockTablet.labelMain.backgroundColor = UIColor.clear
        clockTablet.isHidden = true
        
        setTimerDetails()
        startClock()
    }
    
    
    func setTimerDetails(){
        
        let data = recountTimersData(local_current_game)
        
        if data.2 == -1 {
            onX()
        } else {
            clockTablet.initTimer(from/(3600*24),all/(3600*24))
        }
        
        
    }
    
    func startClock(){
        
        clockTablet.isHidden = false

        clockTablet.doScheduledTimer()
        
    }
    
    
    
    @IBAction func onCopyNumber(){
        
        delegate?.openHistory(self)
        
    }
    
    func countDownDidFall(from: Int, left: Int){
        
    }
    
    func countDownFinished(){
        
    }

    
}
