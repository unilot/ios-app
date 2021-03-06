//
//  LotteryResults.swift
//  Unilot
//
//  Created by Alyona on 10/18/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//



import UIKit
 
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
        
        
        let type = getTabBarTag()
        
        titleMain.text = TR("results") + " " + TR(setting_strings[0][type]).capitalized + " " + TR("drawing2")
        dayTitle.text = getNiceDateFormatString(from: current_game.ending_at)
        unfortunately.text = "" // TR("you_lost_text")
        copyButton.setTitle(TR("details"), for: .normal)
        
       // clockTablet.labelMain.frame.origin = CGPoint(x: 0,
         //                                            y: -clockTablet.labelMain.frame.height * 0.35)
        
        setTimersLabel()
        
    }
    
    
    func setTimersLabel(){
        
        clockTablet.createBody(self)
        clockTablet.labelMain.font = UIFont(name: kFont_Regular, size: 500)
        clockTablet.labelMain.adjustsFontSizeToFitWidth = true
        clockTablet.labelMain.textColor = UIColor.black
        clockTablet.labelMain.backgroundColor = UIColor.clear
        clockTablet.isHidden = true
        
        
        if users_account_wallets.count > 0 {
            
            unfortunately.text =  TR("you_lost_text")

            if games_list[kTypeMonth] != nil {

                butHey.text =  TR("you_take_part_in_bonus:")

                endLabel.text = TR("left_before_end")
                endLabel.numberOfLines = 3
                days.numberOfLines = 3
//                days.text = getDaysWord(3).capitalized

                setTimerDetails()
                startClock()
                
            } else {
                
                butHey.text = " "
 
                endLabel.text = " "
                days.text = " "
            }
            
        } else {
            
            clockTablet.frame = CGRect(x: clockTablet.frame.origin.x,
                                       y: clockTablet.frame.origin.y,
                                       width: clockTablet.borderWidth, height: 2)
            
            clockTablet.reloadInputViews()
            unfortunately.text = " "
            butHey.text = TR("we_dont_know_your_wallet")
            endLabel.text = TR(" ")
            days.text = TR(" ")
        }
        
    }
    
    func setTimerDetails(){
        
        if  let gameWeek = games_list[kTypeMonth]{
            
            let data = recountTimersData(gameWeek)

            if data.2 > -1 {
                
                let startingPoint = data.0/(3600*24) + ( data.1 > 0 ?  1 : 0 )
                clockTablet.initTimer(startingPoint,0)
                if users_account_wallets.count > 0 {
                    days.text = getDaysWord(clockTablet.totalCounts)
                }
                
                clockTablet.updateLabels()
            }  
        }
    }
    
    
    func startClock(){
        
        clockTablet.isHidden = false

//        clockTablet.doScheduledTimer()
        
    }
    
    
    @IBAction func onCopyNumber(){
        
        delegate?.openHistory(self)
        
    }
    
    func countDownDidFall(from: Int, left: Int){
        
    }
    
    func countDownFinished(){
        
    }

    override func onX(_ duration: Double = 0.4) {
        
//        clockTablet.endTimer()
        
        super.onX(duration)
         
    }
}
