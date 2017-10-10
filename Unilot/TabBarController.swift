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
        
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = true
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
//        imageView.backgroundColor = [UIColor colorWithPatternImage:i];
//        [[self view] addSubview:imageView];
//        [[self view] sendSubviewToBack:imageView];
//        [[self view] setOpaque:NO];
//        [[self view] setBackgroundColor:[UIColor clearColor]];
//        [imageView release];
        
        

        sendInitNetWork()
    }


    
    func getVCFromName(_ name: String) -> UIViewController{
        
        let storyBoard = UIStoryboard(name: "Main", bundle : nil )
        let contrller = storyBoard.instantiateViewController(withIdentifier: name)
        
        return contrller
    }
  
    
    func createAllPages(){
        
        let view_controller_1 = getVCFromName("SB_Main_View") as! MainView
        view_controller_1.titleMain.text = "Дневная лотерея"
        let nc1 = UINavigationController(rootViewController: view_controller_1)
        
        let view_controller_2 = getVCFromName("SB_Main_View") as! MainView
        view_controller_2.titleMain.text = "Месячная лотерея"
        let nc2 = UINavigationController(rootViewController: view_controller_2)

        let view_controller_3 = getVCFromName("SB_Main_View") as! MainView
        view_controller_3.titleMain.text = "Бонусная лотерея"
        let nc3 = UINavigationController(rootViewController: view_controller_3)
        
        
        let view_controller_4 = getVCFromName("SB_Profile") as! ProfileView
        let nc4 = UINavigationController(rootViewController: view_controller_4)
        
        self.viewControllers = [nc1, nc2, nc3, nc4]
    }
    
    
    func sendInitNetWork(){
        NetWork.startSession { (error : String?) in
            
            if error != nil {
                SCLAlertView().showError(" ", subTitle: error!)
            }
            
        }
        
    }
    
    override func initNavigationData(){
        
    }
}
