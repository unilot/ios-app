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

    
    
    
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        
//        if let fromView = tabBarController.selectedViewController?.view, let toView = viewController.view {
//            
//            if fromView == toView {
//                return false
//            }
//            
//            UIView.transition(from: fromView, to: toView, duration: 0.2, options: .transitionCrossDissolve) { (finished) in
//            }
//        }
//        
//        return true
//    }
//    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        
        UITabBar.appearance().backgroundColor = UIColor.clear
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = UIColor.clear
        
        
        
        
        let fon  = create_fon_view(self.view.frame.size)
        self.view.insertSubview(fon, at: 0)
 


    
    }
    

 
    
    @IBAction func onInfoBarButton(_ sender: UIBarButtonItem){
         
        let viewWithPlaces = InfoView.createInfoView()
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: -1)
        
        
    }
    
    
    
    func getVCFromName(_ name: String) -> UIViewController{
        
        let storyBoard = UIStoryboard(name: "Main", bundle : nil )
        let contrller = storyBoard.instantiateViewController(withIdentifier: name)
        
        return contrller
    }
  
    
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
