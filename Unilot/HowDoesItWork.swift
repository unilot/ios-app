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
        
        file_name = "Terms"
        
        view_name = "How does it work"

        
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black

    }
}

