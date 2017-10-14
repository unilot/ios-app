//
//  TabBarController.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import SCLAlertView


class TabBarController: LxTabBarController  {

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         
        var tabFrame: CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.height - tabFrame.height - 5
        self.tabBar.frame = tabFrame
        
//        setNavBar()
    }
    
    override func viewDidLoad() {
        
        //UITabBar.appearance().tintColor = UIColor.white
        let attributes = [NSFontAttributeName:UIFont(name: kFont_Light, size: 14)!,NSForegroundColorAttributeName:UIColor.white]
        let attributes1 = [NSFontAttributeName:UIFont(name: kFont_Regular, size: 14)!,NSForegroundColorAttributeName: kColorLightYellow]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributes1, for: .selected)


        super.viewDidLoad()
        
        setNavBar()

        setFon()

        setTabBar()
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

    func setNavBar(){
        
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        
        navigationController?.updateFocusIfNeeded()
    }
    
    
    //MARK: - button
    
    @IBAction func onInfoBarButton(_ sender: UIBarButtonItem){
         
        let viewWithPlaces = InfoView.createInfoView()
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: -1)
        
        
    }
    
    
    //MARK: - left
    
    func createAllPages(){
        
        let view_controller_1 = getVCFromName("SB_Main_View") as! MainView
        let nc1 = UINavigationController(rootViewController: view_controller_1)

        let view_controller_2 = getVCFromName("SB_Main_View") as! MainView
        let nc2 = UINavigationController(rootViewController: view_controller_2)

        let view_controller_3 = getVCFromName("SB_Bonus") as! BonusView
        let nc3 = UINavigationController(rootViewController: view_controller_3)

        
        let view_controller_4 = getVCFromName("SB_Profile") as! ProfileView
        let nc4 = UINavigationController(rootViewController: view_controller_4)

        
        let tb1 =  UITabBarItem(title: TR("Дневная"),
                                image: UIImage(named:"`1day-x3"),
                                tag: 0 )
        
        
        let tb2 =  UITabBarItem(title: TR("Недельная"),
                                image: UIImage(named:"`7day-x3"),
                                tag: 1)
        

        let tb3 =  UITabBarItem(title: TR("Бонусная"),
                                image: UIImage(named:"`31day-x3"),
                                tag: 2)

        
        
        let tb4  =  UITabBarItem(title: TR("Профайл"),
                                 image: UIImage(named:"`profile-x3"),
                                 tag: 3)
        
        self.viewControllers = [nc1, nc2, nc3, nc4]
        self.tabBar.items = [tb1,tb2,tb3,tb4]
    }
    

    
    
}
