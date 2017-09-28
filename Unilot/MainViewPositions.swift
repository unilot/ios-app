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
        
        setButtonView()
        
        setLoadingSign()
        
        
     }
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        moneyTablet.createBody()
        
        clockTablet.createBody(self)
        
        fillWithData()
        
    }
    
    func fillWithData(){
        
    }
    
    
    //MARK: - Set all views
    
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

    
    
    //MARK: -  CountDownTimeDelegate
    
    func countDownDidFall(from: Int, left: Int){
        
        let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
        
        setLoadingSign(toWidth: newWidth )
        
    }
    
    
    
    func countDownFinished(){
        
    }
    
    
    //MARK: - onButtons

         
    @IBAction func onPrizePlaces(){
        
    }
    
    
    @IBAction func onTakePart(){
        
    }
}


