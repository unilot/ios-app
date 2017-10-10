//
//  TabBarController.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit



class TabBarController: UITabBarController  {
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
    
    }
}
