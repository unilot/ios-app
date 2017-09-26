//
//  TabBarController.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController  {

    @IBOutlet var menuButton:UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationData()
        
    }
    
    
    func initNavigationData(){
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
}
