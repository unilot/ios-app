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
        
        setMenuButton()

        hideStatusBar()

        setTitle()
                
    }
    
    
    
    func setTitle(){

        let image = setColorForImage(CGSize(width: 100, height: 20), "unilotmenu-item")

        tabBarController?.navigationItem.titleView = image
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
    
    
    
    
    func setMenuButton(){
        
        navigationController?.initNavigationData()
        
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
