//
//  YouWin.swift
//  Unilot
//
//  Created by Alyona on 10/22/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//



import UIKit
import SCLAlertView



class YouWin: PopUpCore {
    
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!

    @IBOutlet weak var priceETH: UILabel!
    @IBOutlet weak var priceUSD: UILabel!

    @IBOutlet weak var showButton: UIButton!
 
    var user_data = UserForGame()
    
    
    class func createYouWin() -> YouWin {
        let myClassNib = UINib(nibName: "YouWin", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! YouWin
    }
    
    
    
    override func setInitBorders(){
        
        playWin()
        
        super.setInitBorders()

        self.layer.borderWidth = 0
        
        text1.text = TR("Поздравляем!")
        text2.text = TR("Вы победили!")
        text3.text = String(format : TR("Вы заняли %d место и выиграли"),user_data.position)
        showButton.setTitle(TR("История розыгрыша"), for: .normal)
        priceETH.text = "\(user_data.prize_amount)"
        priceUSD.text = "US $ \(user_data.prize_amount_fiat)"
    }
    
 
    @IBAction func onShow(){
        delegate?.openHistory(self)
    }

    
    @IBAction override func onX(_ duration: Double) {
 
        UIView.animate(withDuration: duration, animations: {
            
            self.layer.opacity = 0.0
            self.bigButtonFade?.layer.opacity = 0.0
            
        }) { (_ animate : Bool) in
            
            self.bigButtonFade?.removeFromSuperview()
            self.bigButtonFade = nil
            self.removeFromSuperview()
        }
    }
 
    
}
