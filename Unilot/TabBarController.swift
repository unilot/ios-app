//
//  TabBarController.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import SCLAlertView


class TabBarController: UITabBarController  {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         
        var tabFrame: CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.height - tabFrame.height - 5
        self.tabBar.frame = tabFrame        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 0..<tabBar.items!.count {
            
            tabBar.items![i].title = TR(tabbar_strings[i])
            
        }
        
    }
    
    
    override func viewDidLoad() {
        
        //UITabBar.appearance().tintColor = UIColor.white
        let attributes = [NSFontAttributeName:UIFont(name: kFont_Light, size: 14)!,NSForegroundColorAttributeName:UIColor.white]
        let attributes1 = [NSFontAttributeName:UIFont(name: kFont_Regular, size: 14)!,NSForegroundColorAttributeName: kColorLightYellow]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributes1, for: .selected)


        super.viewDidLoad()
        
        setNavControllerClear()

        setFon()

        setTabBar()
        
        switchToTab()
        
        

    }
    
    
    func setFon(){
        
        let fon  = create_fon_view(self.view.frame.size)
        self.view.insertSubview(fon, at: 0)
        
    }
    
    
    func setTabBar(){
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        
        UITabBar.appearance().backgroundColor = UIColor.clear
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = UIColor.clear

        
    }
 
    
    func switchToTab(){
        
        if open_from_notif != nil {
            
            let notif_type = Int(NotifApp.getDataFromNotifString(open_from_notif,2))
            
            selectedIndex = getTabBarTag(notif_type)
        }
        
    }
 

    
    
}
