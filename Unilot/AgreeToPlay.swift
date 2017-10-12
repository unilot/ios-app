//
//  AgreeToPlay.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import SCLAlertView



class AgreeToPlay: UIView, CountDownTimeDelegate {
    
    @IBOutlet weak var clockTablet: CountDownSimpleTime!

    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    @IBOutlet weak var endLabel: UILabel!

    @IBOutlet weak var copyButton: UIButton!

    class func createAgreeToPlay() -> AgreeToPlay {
        let myClassNib = UINib(nibName: "AgreeToPlay", bundle: nil)
         return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! AgreeToPlay
    }
    
    
    
    func initView(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = kColorLightGray.cgColor
        
        copyButton.layer.borderWidth = 1
        copyButton.layer.borderColor = UIColor.lightGray.cgColor
        copyButton.layer.cornerRadius = 4
        
        clockTablet.createBody(self)
        clockTablet.labelMain.textColor = UIColor.darkGray
        clockTablet.initTimer(1500, 2500)
        clockTablet.doScheduledTimer()
 
    }
    
    func startClock(){
    
        clockTablet.doScheduledTimer()

    }
    
    
    
    
    @IBAction func onX(){
        UIView.animate(withDuration: 0.4, animations: {
            self.frame = CGRect(x: 10,
                                y: -self.frame.height,
                                width: self.frame.width,
                                height: self.frame.height)
            self.layer.opacity = 0.0
        }) { (animate : Bool) in
            self.removeFromSuperview()
        }
        
    }
    
    
    
    @IBAction func onCopyNumber(){

        saveToClipboard(kNumberOfOurPursle)

     }
    
    func countDownDidFall(from: Int, left: Int){
        
    }
    
    func countDownFinished(){
        
    }

}
