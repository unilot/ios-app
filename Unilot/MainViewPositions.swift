//
//  MainViewPositions.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit

class MainViewPositions: ControllerCore, CountDownTimeDelegate {
    
    @IBOutlet weak var loadingSignFirst: UIImageView!
    @IBOutlet weak var loadingSignProgress: UIImageView!
    
    
    @IBOutlet weak var titleMain: UILabel!
    @IBOutlet weak var titleUntilTheEnd: UILabel!
    @IBOutlet weak var titlePrize: UILabel!
    @IBOutlet weak var takePartEth: UILabel!

    
    @IBOutlet weak var takePart: UIButton!
    @IBOutlet weak var takePartFon: UIImageView!
    
    
    @IBOutlet weak var prizePlaces: UIButton!
    
    @IBOutlet weak var usSum: UILabel!
    @IBOutlet weak var peopleCount: UILabel!
    
    @IBOutlet weak var moneyTablet: CountUppMoney!
    @IBOutlet weak var clockTablet: CountDownSimpleTime!
    
    
    //MARK: - Views Load override
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setMenuButton()
        
        
        setButtonView()

        moneyTablet.createBody()
        
        clockTablet.createBody(self)
        
        fillWithData()


        
     }
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        moneyTablet.doScheduledTimer()
        
        clockTablet.doScheduledTimer()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
       
        moneyTablet.endTimer()
        
        clockTablet.endTimer()
        
    }
    
    func fillWithData(){
        
    }
    
    
    //MARK: - Set all views
    
    func setMenuButton(){
        
        let imageItem = setColorForImage(CGSize(width: 30, height: 30), "menu")
        let backItem = UIBarButtonItem(customView: imageItem)
        tabBarController?.navigationItem.backBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = backItem
        
        if let nav = (tabBarController as? TabBarController ) {
            nav.initNavigationData(backItem)
        }
    }
    
    
    
    func setButtonView(){
        
        prizePlaces.layer.borderWidth = 0.5
        prizePlaces.layer.borderColor = UIColor.gray.cgColor
        prizePlaces.layer.cornerRadius = prizePlaces.frame.height/2
        prizePlaces.backgroundColor = UIColor.clear
        
        
        takePartFon.image = UIImage(named: "loadingSign")
        takePartFon.layer.cornerRadius = takePartFon.frame.height/2
        takePartFon.contentMode = .scaleAspectFill
        takePartFon.clipsToBounds = true
    }
    
    
    func setLoadingSign(toWidth: CGFloat = 0){
        
        let rect = loadingSignProgress.frame
        
        loadingSignProgress.frame = CGRect(x: rect.origin.x,
                                           y: rect.origin.y,
                                           width: toWidth,
                                           height: rect.size.height)
    }

    func changeProgressLine(from: Int, left: Int){
        
        let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
        
        setLoadingSign(toWidth: newWidth )
        
    }

    //MARK: -  CountDownTimeControll
    
    func pauseCountings(){
        
    }

    
    
    //MARK: -  CountDownTimeDelegate
    
    func countDownDidFall(from: Int, left: Int){
        
        let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
        
        setLoadingSign(toWidth: newWidth )
        
    }
    
    
    
    func countDownFinished(){
        
        clockTablet.endTimer()
    }
    
    
    //MARK: - onButtons

         
    @IBAction func onPrizePlaces(){
        let viewWithPlaces = TotalPrizeFond.createTotalPrizeFond()
        viewWithPlaces.layoutIfNeeded()
        viewWithPlaces.layer.opacity = 0.0
        viewWithPlaces.frame = CGRect(x: 10,
                                 y: view.frame.height,
                                 width: view.frame.width - 20,
                                 height: view.frame.height - 150)
        
        viewWithPlaces.initView()
        view.addSubview(viewWithPlaces)
        
        UIView.animate(withDuration: 0.4) {
            viewWithPlaces.layer.opacity = 1.0
            viewWithPlaces.frame = CGRect(x: 10,
                                     y: 70,
                                     width: viewWithPlaces.frame.width,
                                     height: viewWithPlaces.frame.height)
        }
         
    }
    
    
    @IBAction func onTakePart(){
        
        let viewAgree = AgreeToPlay.createAgreeToPlay()
        viewAgree.layoutIfNeeded()
        viewAgree.layer.opacity = 0.0
        viewAgree.frame = CGRect(x: 10,
                                 y: view.frame.height,
                                 width: view.frame.width - 20,
                                 height: view.frame.height - 150)

        viewAgree.initView()
        view.addSubview(viewAgree)
        
        UIView.animate(withDuration: 0.4) {
            viewAgree.layer.opacity = 1.0
            viewAgree.frame = CGRect(x: 10,
                                     y: 70,
                                     width: viewAgree.frame.width,
                                     height: viewAgree.frame.height)
        }
        
        
        viewAgree.clockTablet.initTimer(1500, 2500)
        viewAgree.clockTablet.doScheduledTimer()
        
        

    }
    
    
    
}


