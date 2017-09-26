//
//  ViewController.swift
//  FlippingLabelExample
//
//  Created by Matthias Mellouli on 2017-02-03.
//  Copyright © 2017 Matthias Mellouli. All rights reserved.
//

import UIKit

class MainView: UIViewController, CountDownTabletDelegate {
 

    @IBOutlet weak var bgView: UIImageView!


    @IBOutlet weak var loadingSignFirst: UIImageView!
    @IBOutlet weak var loadingSignProgress: UIImageView!
    
    
    @IBOutlet weak var takePart: UIButton!
    
    @IBOutlet weak var prizePlaces: UIButton!
    
    @IBOutlet weak var usSum: UILabel!
    @IBOutlet weak var ethSum: UILabel!
    
    @IBOutlet weak var clockTablet: CountDownTablet!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearNavBar()
        
        addParallaxToView(vw: bgView)
        
        
        
        setButtonView()
        
        setLoadingSign(toWidth: 0)
        
        setMenuButton()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setClockTable()
    }
    
    func setClockTable(){
        
        if clockTablet.createBody() {
            clockTablet.delegate = self
            clockTablet.startTimer(1500)

        }

    }


    
    
    func setButtonView(){
        prizePlaces.layer.borderWidth = 1
        prizePlaces.layer.borderColor = UIColor.white.cgColor
        prizePlaces.layer.cornerRadius = prizePlaces.frame.height/2
        prizePlaces.backgroundColor = UIColor.clear
    }
    
    
    func setLoadingSign(toWidth: CGFloat){
        
        let rect = loadingSignProgress.frame
        
        loadingSignProgress.frame = CGRect(x: rect.origin.x,
                                           y: rect.origin.y,
                                           width: toWidth,
                                           height: rect.size.height)
    }
    
    //MARK: -  CountDownTabletDelegate
    
    func countDownDidFall( from: Int, left: Int){
        
        let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
        
        setLoadingSign(toWidth: newWidth )
        
        print(newWidth)
        
    }
    
    func countDownFinished(){
        
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
    

}


