//
//  MainViewWatch.swift
//  Watch Extension
//
//  Created by Alyona2013 on 2/12/18.
//  Copyright © 2018 Vovasoft. All rights reserved.
//

import Foundation
import WatchKit

class MainViewWatch : WKInterfaceController {
    
    @IBOutlet var labelLogo: WKInterfaceLabel!
    @IBOutlet var labelTimeLeft: WKInterfaceLabel!
    @IBOutlet var labelTime: WKInterfaceLabel!

    @IBOutlet var wkGroup: WKInterfaceGroup!

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        labelTime.setText("23:23")
        wkGroup.setBackgroundImageNamed("bg_watch")
        
//        var fontSize = CGFloat(50)
//        var text = "23:23"
//        var cstmFont = UIFont(name: "Roboto", size: fontSize)!
//        var attrStr = NSAttributedString(string: text, attributes:
//            [NSFontAttributeName: cstmFont])
//        firstLabel.setAttributedText(attrStr)
//
//        fontSize = CGFloat(36)
//        text = "right on!"
//        cstmFont = UIFont(name: "Exo-Regular", size: fontSize)!
//        attrStr = NSAttributedString(string: text, attributes:
//            [NSFontAttributeName: cstmFont])
//        secondLabel.setAttributedText(attrStr)
        
        
//        labelTime.forwardingTarget(for: Selector!)
     }
    
}
