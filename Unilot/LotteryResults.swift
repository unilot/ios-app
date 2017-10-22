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
    
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var copyButton: UIButton!
    
    class func createLotteryResults() -> LotteryResults {
        let myClassNib = UINib(nibName: "LotteryResults", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! LotteryResults
    }
    
    
    
    override func setInitBorders(){
        
        super.setInitBorders()
        
        clockTablet.layoutIfNeeded()
        
        clockTablet.createBody(self)
        clockTablet.initTimer(30, 30)
        clockTablet.labelMain.frame.origin = CGPoint(x: 0,
                                                     y: -clockTablet.labelMain.frame.height * 0.35)
        
        clockTablet.labelMain.font = UIFont(name: kFont_Regular, size: 500)
        clockTablet.labelMain.textColor = UIColor.black
        clockTablet.labelMain.backgroundColor = UIColor.clear
        clockTablet.isHidden = true
        
        startClock()
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
