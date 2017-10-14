//
//  ControllerCore.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import NVActivityIndicatorView
import SCLAlertView


class ControllerCore: UIViewController, NVActivityIndicatorViewable {

    var activityIndicatorView : NVActivityIndicatorView?
 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addSwipeForMenuOpen()

        setTitle()
    }
    
    
    func setTitle() {
        
        let image = setImageForTitle(CGSize(width: 100, height: 40), "unilotmenu-item")
        
        tabBarController?.navigationItem.titleView = image
        
        
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        

        navigationController?.updateFocusIfNeeded()
    }
    
    func addSwipeForMenuOpen(){

        if navigationController?.revealViewController() != nil {
            navigationController?.view.addGestureRecognizer(navigationController!.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
    func goToMainView(){
        
        let navController = self.navigationController!
        
        
        let rootViewController = getVCFromName("SB_TabBarController") as! TabBarController
        rootViewController.selectedIndex = currentTabBarLottery

        
        var cntrllrs =   navController.viewControllers
        cntrllrs.insert(rootViewController, at: 0)
        
        navController.setViewControllers(cntrllrs, animated: false)
        navigationController?.popViewController(animated: true)

        
        
    }
    
    @IBAction func onBackMenuArrow(){
     
        goToMainView()
    }


    //MARK: - activityView

    func showActivityViewIndicator(){
        
        let size = CGSize(width: 40 , height: 40)

        startAnimating(size, type : NVActivityIndicatorType.lineScalePulseOut )
        
 
    }
    
    func hideActivityViewIndicator(){
        
        stopAnimating()
    }
    
    //MARK: - onButtons
    
    
    func onOpenMenu(){
        navigationController?.popViewController(animated: true)
    }
 
    

}
