//
//  CountDownSimpleDays.swift
//  Unilot
//
//  Created by Alyona on 10/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


class CountDownSimpleDays: CountDownFullTimer  {
    
    override func createBodyTimers(){
        
        createLabelBody(self.frame.height)
        
    }
    
    override func labelFormatted(_ totalUnits: Int) -> String {
        
        
        return String(format:"%02i", totalUnits)
    }
    
    
    
}
