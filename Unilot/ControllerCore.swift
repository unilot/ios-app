//
//  ControllerCore.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class ControllerCore: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var bgView: UIImageView!

    var activityIndicatorView : NVActivityIndicatorView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.layoutIfNeeded()

        clearNavBar()
        
        addParallaxToView(vw: bgView)
        
        setMenuButton()
        
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
//        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        
    }
    
    
    func setMenuButton(){
        
        navigationItem.backBarButtonItem = nil
        
//        let imageItem = setColorForImage(CGSize(width: 30, height: 30), "menu")


//        let backItem = UIBarButtonItem(customView: imageItem)
//        backItem.target = self
//        backItem.action = #selector(ControllerCore.onOpenMenu)
        
        
        let backItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(ControllerCore.onOpenMenu))
 
        
        //UIColor.whiteColor()

//        UIBarButtonItem.appearance().tintColor = newColor // UIColor.gray
        backItem.title = nil
        navigationItem.leftBarButtonItem = backItem
        
        self.navigationController?.navigationBar.tintColor = kColorLightOrange

    }
    
    
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
    
    
    
    
    func setTabBarItem(){
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        
    }
    
    func setColorForLabel(_ sizeOfView : CGSize, _ text : String) -> UIView{
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width:  sizeOfView.width,
                                          height: sizeOfView.height))
        bgView.backgroundColor = UIColor.clear

        let textLayer = CATextLayer()
        textLayer.frame = bgView.frame
        textLayer.string = text
        textLayer.fontSize = 28
        textLayer.alignmentMode = kCAAlignmentCenter
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bgView.frame
        gradientLayer.colors = [
            kColorLightYellow.cgColor,
            kColorLightOrange.cgColor
        ]
        
        //Here you can adjust the filling
        gradientLayer.locations = [0.5, 1.0]
        
        gradientLayer.mask = textLayer
        bgView.layer.addSublayer(gradientLayer)
        
        return bgView
    }
    
    func setColorForImage(_ sizeOfView : CGSize, _ imageName : String) -> UIView{
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width:  sizeOfView.width,
                                          height: sizeOfView.height))
        bgView.backgroundColor = UIColor.clear
        
        let myImage = UIImage(named: imageName)?.cgImage

        let myLayer = CALayer()
        myLayer.frame = bgView.frame
        myLayer.contents = myImage
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bgView.frame
        gradientLayer.colors = [
            kColorLightYellow.cgColor,
            kColorLightOrange.cgColor
        ]

        
        //Here you can adjust the filling
        gradientLayer.locations = [0.5, 1.0]
        
        gradientLayer.mask = myLayer
        bgView.layer.addSublayer(gradientLayer)
        
        return bgView
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
