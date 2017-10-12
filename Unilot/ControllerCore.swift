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
        
        addMenuButton()
    }
    
    func addMenuButton() {
        
        self.navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    func setTitle(){

        let image = setImageForTitle(CGSize(width: 100, height: 40), "unilotmenu-item")

        tabBarController?.navigationItem.titleView = image
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

    }
     
    
    
    func addSwipeForMenuOpen(){

        if navigationController?.revealViewController() != nil {
            navigationController?.view.addGestureRecognizer(navigationController!.revealViewController().panGestureRecognizer())
        }
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
