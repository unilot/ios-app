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
    
    class func createYouWin() -> YouWin {
        let myClassNib = UINib(nibName: "YouWin", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! YouWin
    }
    
    
    
    override func setInitBorders(){
        
        super.setInitBorders()
        
        self.layer.borderWidth = 0
 
    }
    
 
    @IBAction func onShow(){
        onX()
    }
    
    
}
