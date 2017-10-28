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
        
        view_name = TR("Как это работает")

        
        super.viewDidLoad()
//        self.navigationController?.navigationItem.titleView = title
        UINavigationBar.appearance().tintColor = kColorMenuPeach

    }
}

