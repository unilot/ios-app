//
//  OnScrollItemCore.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
 
class  OnScrollItemCore : UIView {

    @IBOutlet weak var titleMain: UILabel!

    func didLoad(_ indexNum : Int) {
        
        // clean from XIB
        cleanFromXib()
        
        // names of titleMain
        setMainTitle(indexNum)
        
        // load main items
        loadMainSubViews()
        
        // open view for user
        animateAppearance()        
    }
    
    
    //MARK: - Override

    func setMainTitle (_ indexNum : Int){

        
    }
    
    
    func loadMainSubViews(){
        
    }

    
    func fillLocalGameData(){
        
    }
    
    
    func viewDataReload(_ overrideData : Bool = true){

    }
    
    func stopAllSchedule(){
        
    }

    
    func onUserOpenView(){

        viewDataReload()

    }
    
    func onUserCloseView(){
         
        stopAllSchedule()

    }
    
    
    //MARK: - Functions
    
    func cleanFromXib(){
        
        layer.opacity = 0.0
        backgroundColor = UIColor.clear
        setNeedsLayout()
        layoutIfNeeded()
    }

    func animateAppearance(){
        
        if self.layer.opacity < 1.0 {
            UIView.animate(withDuration: 0.2) {
                self.layer.opacity = 1.0
            }
        }
        
    }
    
    
    func animateExit(){
        
        if self.layer.opacity > 0.0 {
            UIView.animate(withDuration: 0.2) {
                self.layer.opacity = 0.0
            }
        }
        
    }
}
