//
//  HowDoesItWork.swift
//  Unilot
//
//  Created by Alyona on 10/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class HowDoesItWork : TextViewCore {
    
    override func viewDidLoad() {
        
        view_name = TR("Как это работает")
         
        super.viewDidLoad()
        
        textView.text = getTextFromFileInfo()

    }
    
    override  func addText() {

        
    }
}

