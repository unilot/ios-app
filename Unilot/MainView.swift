//
//  ViewController.swift
//  FlippingLabelExample
//
//  Created by Matthias Mellouli on 2017-02-03.
//  Copyright © 2017 Matthias Mellouli. All rights reserved.
//

import UIKit

class MainView: UIViewController, CountDownTimeDelegate {
 

    @IBOutlet weak var bgView: UIImageView!


    @IBOutlet weak var loadingSignFirst: UIImageView!
    @IBOutlet weak var loadingSignProgress: UIImageView!
    
    
    @IBOutlet weak var takePart: UIButton!
    @IBOutlet weak var takePartEth: UILabel!
    @IBOutlet weak var takePartFon: UIImageView!

    
    
    @IBOutlet weak var prizePlaces: UIButton!
    
    @IBOutlet weak var usSum: UILabel!
    @IBOutlet weak var ethSum: UILabel!
    
    @IBOutlet weak var moneyTablet: CountUppMoney!
    @IBOutlet weak var clockTablet: CountDownSimpleTime!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearNavBar()
        
        addParallaxToView(vw: bgView)
        
        
        setButtonView()
        
        setLoadingSign(toWidth: 0)
        
        setMenuButton()
        
        setTabBarItem()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setMoneyTable()

        setClockTable()

    }
    
    func setMoneyTable(){
        
        if moneyTablet.createBody() {
            moneyTablet.startTimer(0, 300)
        }

    }

    func setClockTable(){
        
        if clockTablet.createBody() {
            clockTablet.delegate = self
            clockTablet.startTimer(1500, 2500)
            
        }
        
    }

    
    
    func setButtonView(){
        
        prizePlaces.layer.borderWidth = 0.5
        prizePlaces.layer.borderColor = UIColor.gray.cgColor//UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.6).cgColor
        prizePlaces.layer.cornerRadius = prizePlaces.frame.height/2
        prizePlaces.backgroundColor = UIColor.clear
        
        
        takePartFon.image = UIImage(named: "loadingSign")
        takePartFon.layer.cornerRadius = takePartFon.frame.height/2
        takePartFon.contentMode = .scaleAspectFill
        takePartFon.clipsToBounds = true

        takePartEth.text = "0,0005 Eth"
    }
    
    
    func setLoadingSign(toWidth: CGFloat){
        
        let rect = loadingSignProgress.frame
        
        loadingSignProgress.frame = CGRect(x: rect.origin.x,
                                           y: rect.origin.y,
                                           width: toWidth,
                                           height: rect.size.height)
    }
    
    //MARK: -  CountDownTimeDelegate
    
    func countDownDidFall(_ tag: Int, from: Int, left: Int){
        
        if tag == clockTablet.tag {
            let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
            
            setLoadingSign(toWidth: newWidth )
            
        }
        
    }
    
    func countDownFinished(_ tag: Int){
        
    }

    
    
    //MARK: Add effects
    
    func setMenuButton(){
        
        navigationItem.backBarButtonItem = nil
        
        let backItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(MainView.onOpenMenu))
        backItem.title = nil
        navigationItem.leftBarButtonItem = backItem

        
    }
    
    func onOpenMenu(){
        navigationController?.popViewController(animated: true)
    }
    
    func clearNavBar(){

        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Whatever..."
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
        
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
}


