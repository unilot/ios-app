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
    
    var widthProgress = CGFloat(-1)
        
    //MARK: - Views Load override

//    viewWillLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = UIColor.clear

        setButtonView()

    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        if widthProgress == -1 {
            
            fillWithData()

            setLoadingSign(toWidth: 0)

            startSchedule()
        }
        
        
    }
    
  
//    override func addMenuButton() {
//        
//        tabBarController?.navigationItem.leftBarButtonItem = createMenuButton()
//    }
    
    func fillWithData(){
        
    }
    
//    
//    //MARK: - SetSwipes
//    
//    func setSwipesGestures(){
//        
//        let left = UISwipeGestureRecognizer(target: self, action: #selector(MainViewPositions.swipeLeft))
//        left.direction = .left
//        self.view.addGestureRecognizer(left)
//        
//        let right = UISwipeGestureRecognizer(target: self, action: #selector(MainViewPositions.swipeRight))
//        right.direction = .right
//        self.view.addGestureRecognizer(right)
//    }
//    
//    
//    func swipeLeft(){
//        let total = self.tabBarController!.viewControllers!.count - 1
//        tabBarController!.selectedIndex = min(total, tabBarController!.selectedIndex + 1)
//
//    }
//    
//    func swipeRight(){
//        tabBarController!.selectedIndex = max(0, tabBarController!.selectedIndex - 1)
//    }
    
    //MARK: - Set all views
    
    func setTakePartView(){
        
        takePartFon.image = UIImage(named: "loadingSign")
        takePartFon.layer.cornerRadius = takePartFon.frame.height/2
        takePartFon.contentMode = .scaleAspectFill
        takePartFon.clipsToBounds = true
        
    }
    
    override func addSwipeForMenuOpen(){
        
//        if myTabBarItem!.tag == 0 &&
//            tabBarController?.revealViewController() != nil {
//        view.addGestureRecognizer(tabBarController!.revealViewController().panGestureRecognizer())
//        }
    }
    
     
    func setButtonView(){

        prizePlaces.layer.cornerRadius = prizePlaces.frame.height/2
        prizePlaces.backgroundColor = UIColor.clear
        
    }
    
    //MARK: -  LoadingSign

    
    func setLoadingSign(toWidth: CGFloat ){
        
        let rect = loadingSignFirst.frame
        
        let _loadingSignProgress = loadingSignProgress
        
        widthProgress = toWidth
        

        let widthOfFire = rect.size.width - 2  - toWidth
        
        UIView.animate(withDuration: 0.05) {
            _loadingSignProgress?.frame = CGRect(x: rect.origin.x + 1 + toWidth,
                                               y: rect.origin.y + 1,
                                               width: widthOfFire,
                                               height: rect.size.height - 2)
        }
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
        

    }
    
    //MARK: - timers
    
    func addTimersBody(){
        
        
        
    }
    
    func startSchedule(){
        
    }
    
    
    
    //MARK: - onButtons

         
    @IBAction func onHowDoesItWork(){
        
        let viewWithPlaces = TotalPrizeFond.createTotalPrizeFond()
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        
    }
    
    
    
    @IBAction func onPrizePlaces(){
        
        let viewWithPlaces = TotalPrizeFond.createTotalPrizeFond()
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        
    }
    
    
    @IBAction func onTakePart(){
        
        let viewWithPlaces = AgreeToPlay.createAgreeToPlay()
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        

    }
    
    
    
}


