//
//  CDHourL.swift
//  Unilot
//
//  Created by Alyona on 10/29/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


class CDHourL: CountDownFullTimer  {
    
    func createHourCounter(_ delegateNew : CountDownTimeDelegate){
    
        delegate = delegateNew
        createLabelBody(self.frame.height)
    
    }
    
    
    override func labelFormatted(_ totalUnits: Int) -> String {
        
        let minutes = Int(totalUnits) / 60 % 60
        let seconds = Int(totalUnits) % 60
        
        return String(format:"%02i : %02i", minutes, seconds)
    }
    
    
    func isCounting() -> Bool {
        
        return false
    }
    
    
}
