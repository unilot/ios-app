//
//  OnScrollItemCore.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import SCLAlertView

class  OnScrollItemCore : UIView {

    @IBOutlet weak var titleMain: UILabel!

    func didLoad(_ indexNum : Int) {
        
        // clean from XIB
        layer.opacity = 0.0
        backgroundColor = UIColor.clear
        
        // names of titleMain
        setLotteryName(indexNum)
        
        // open view for user

        animateAppearance()

        
    }
    
    func setLotteryName (_ indexNum : Int){

        
    }
    

    func animateAppearance(){
        
        if self.layer.opacity < 1.0 {
            UIView.animate(withDuration: 0.5) {
                self.layer.opacity = 1.0
            }
        }
        
    }
    
    func fillLocalGameData(){
        
    }
    
    func answerOnInitData(){

    }
    
    
    
    //MARK: - APP CLOSED OPENED
    
    func onUserOpenView(){
        
    }
    
    func onUserCloseView(){
         
        
    }
    
}
