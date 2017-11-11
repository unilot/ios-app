//
//  AgreeToPlay.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import SCLAlertView



class AgreeToPlay: PopUpCore, CountDownTimeDelegate {
    
    @IBOutlet weak var trophy: UIImageView!

    @IBOutlet weak var clockTablet: CDTimerPopUp!
    
    
    
    @IBOutlet weak var textBig: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!

    @IBOutlet weak var warningLabel: UILabel!

    @IBOutlet weak var copyButton: UIButton!


    @IBOutlet weak var copy_line: UILabel!

    
    class func createAgreeToPlay() -> AgreeToPlay {
        let myClassNib = UINib(nibName: "AgreeToPlay", bundle: nil)
         return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! AgreeToPlay
    }
    
     override func setInitBorders(){

        super.setInitBorders()
         
        copy_line.text = local_current_game.smart_contract_id
        
        let ptophyUpper = setColorForImage(trophy.frame.size, "trophy-x3")
        trophy.addSubview(ptophyUpper)

        startClock()
        
        let order = getTabBarTag()
        
        let lotteryType = setting_strings[0][order] + " " + TR("drawing3")
        titleMain.text = TR(tabbar_strings[order]) + " " + TR("drawing1") +  " " + app_name.uppercased()
        let floatBet = local_current_game.bet_amount
        textBig.text = String(format: TR("to_participate_you_need"),TR(lotteryType),floatBet)
        endLabel.text = TR("will_be_off_after:")
        warningLabel.text = TR("go_back_after_payment")
        copyButton.setTitle("  " + TR("copy_address"), for: .normal)
    }
    
    
    func startClock(){
        
        let items = recountTimersData(local_current_game)
        
        if items.2 > -1 {
            
            clockTablet.createBody(self)
            clockTablet.setTextColor(UIColor.black)
            clockTablet.labelMain.font = UIFont(name: kFont_Regular, size: 500)
            clockTablet.labelMain.frame.origin = CGPoint(x: 0,
                                                         y: -clockTablet.labelMain.frame.height * 0.4)

            clockTablet.initTimer(items.0, items.1)
            clockTablet.changeTextOnStaticLabels(items.2)
            clockTablet.doScheduledTimer()
            
        } else {
            onX()
        }
        
     }
    
    
    
    @IBAction func onCopyNumber(){

        saveToClipboard(copy_line.text!)

     }
    
    func countDownDidFall(from: Int, left: Int){
  
    }
    
    func countDownFinished(){
        onX()
    }
    
    
    override func onX(_ duration: Double = 0.4) {
        
        clockTablet.endTimer()
        
        super.onX(duration)
        
        
    }

}
