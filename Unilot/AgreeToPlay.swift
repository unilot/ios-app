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
    
    @IBOutlet weak var clockTablet: CountDownSimpleTime!
    
    @IBOutlet weak var textBig: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!

    @IBOutlet weak var copyButton: UIButton!

    @IBOutlet weak var trophy: UIImageView!

    @IBOutlet weak var copy_line: UILabel!

    
    class func createAgreeToPlay() -> AgreeToPlay {
        let myClassNib = UINib(nibName: "AgreeToPlay", bundle: nil)
         return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! AgreeToPlay
    }
    
     override func setInitBorders(){
        
        super.setInitBorders()
         
        copy_line.text = games_list[local_current_game_type]!.smart_contract_id
            
        copyButton.layer.borderWidth = 1
        copyButton.layer.borderColor = UIColor.lightGray.cgColor
        copyButton.layer.cornerRadius = 4
        
        clockTablet.createBody(self)
        clockTablet.labelMain.textColor = UIColor.black
        clockTablet.initTimer(1500, 2500)
        clockTablet.labelMain.font = UIFont(name: kFont_Regular, size: 500)
        clockTablet.labelMain.frame.origin = CGPoint(x: 0,
                                                     y: -clockTablet.labelMain.frame.height * 0.4)
        
        let ptophyUpper = setColorForImage(trophy.frame.size, "trophy-x3")
        trophy.addSubview(ptophyUpper)
 
        startClock()
    }
    
    func startClock(){
    
        clockTablet.doScheduledTimer()

    }
    
    
    
    @IBAction func onCopyNumber(){

        saveToClipboard(copy_line.text!)

     }
    
    func countDownDidFall(from: Int, left: Int){
        
    }
    
    func countDownFinished(){
        
    }

}
