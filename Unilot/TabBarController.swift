//
//  TabBarController.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit




class NavigationController: UINavigationController  {
     
 
    func initNavigationData(_ menuButton : UIBarButtonItem){
        
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            menuButton.style = .plain
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
}

class TabBarController: UITabBarController  {
  
    func initNavigationData(_ menuButton : UIBarButtonItem){
        
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            menuButton.style = .plain

            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
}
