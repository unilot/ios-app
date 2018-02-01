//
//  WalletsAlert.swift
//  Unilot
//
//  Created by Alyona2013 on 2/1/18.
//  Copyright © 2018 Vovasoft. All rights reserved.
//

import UIKit


class WalletsAlert: PopUpCore {
    
    @IBOutlet weak var gotItButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    
    class func createWalletsAlert() -> WalletsAlert {
        let myClassNib = UINib(nibName: "WalletsAlert", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! WalletsAlert
    }
    
    override func setInitBorders(){
        
        gotItButton.setTitle(TR("button_wallets_allert"), for: .normal)
 
        textView.text = TR("text_wallets_allert")
        textView.font = UIFont(name: kFont_Regular, size: sizeOfTextView())
        textView.adjustsFontForContentSizeCategory = true
        
        titleMain.text = TR("title_wallets_allert")
    }
    
    func sizeOfTextView() -> CGFloat{
        
        switch UIScreen.main.nativeBounds.size.height {
            
        case 1136:
            //            printf("iPhone 5 or 5S or 5C");
            return 10
            
        case 1334:
            //            printf("iPhone 6/6S/7/8");
            return 14
            
        case 2208:
            //            printf("iPhone 6+/6S+/7+/8+");
            return 16
            
        case 2436:
            //            printf("iPhone X");
            return 15
            
        default:
            return 20
        }
        
    }
    
}
