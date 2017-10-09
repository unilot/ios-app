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

    @IBOutlet weak var bgView: UIImageView!

    var activityIndicatorView : NVActivityIndicatorView?
 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.layoutIfNeeded()

        clearNavBar()
        
        addParallaxToView()
                
        setTabBarItem()
        
    }
    
    
    
    func clearNavBar(){
        
//        tabBarController?.navigationItem.leftBarButtonItem = settingsButton //This is the IBOutlet variable that you previously added

//        
//        let bar:UINavigationBar! =  self.navigationController?.navigationBar
//        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        bar.shadowImage = UIImage()
//        bar.alpha = 0.0
//        
        
        
//        let frameForSize = tabBarController?.navigationItem.accessibilityFrame
        
//        let imageTitle = UIImageView(image: UIImage(named: "unilotmenu-item"))
        
        let imageTitle = setColorForLabel(CGSize(width: 100, height: 30), "unilot")

//        
//        imageTitle.frame = CGRect(x: frameForSize!.width / 2 - 100,
//                                  y: frameForSize!.height / 2 - 10,
//                                  width: 200, height: 20)
//        imageTitle.contentMode = .scaleAspectFit
//      
        
        
        tabBarController?.navigationItem.titleView = imageTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

    }
    
    

    
    
    func addParallaxToView() {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        bgView.addMotionEffect(group)
    }
    
    
    
    
    func setTabBarItem(){
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        
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
