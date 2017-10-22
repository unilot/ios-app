//
//  PopUpCore.swift
//  Unilot
//
//  Created by Alyona on 10/12/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit



class PopUpCore: UIView  {
    
    @IBOutlet weak var titleMain: UILabel!
    
    var bigButtonFade : UIButton?
    var directionInSign = CGFloat(1)
    
    func setInitBorders(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = kColorLightGray.cgColor
        
    }
    
    //MARK: - actions

    func initView(mainView: UIView, frameView: CGRect, directionSign: CGFloat){
        
        self.layoutIfNeeded()
        
        directionInSign = directionSign
        
        
        bigButtonFade = UIButton(frame: mainView.frame)
        bigButtonFade!.backgroundColor = UIColor.black
        bigButtonFade!.addTarget(self, action: #selector(PopUpCore.onX), for: .touchUpInside)
        bigButtonFade!.layer.opacity = 0.0
        UIApplication.shared.keyWindow?.addSubview(bigButtonFade!)

        
        self.layoutIfNeeded()
        self.layer.opacity = 0.0
        self.frame = CGRect(x: 10,
                            y: directionSign * mainView.frame.height,
                            width:  frameView.width,
                            height: frameView.height)
        
        setInitBorders()
        
        UIApplication.shared.keyWindow?.addSubview(self)
 
        
        UIView.animate(withDuration: 0.4) {
            self.layer.opacity = 1.0
            self.frame = frameView
            self.bigButtonFade?.layer.opacity = 0.6
        }
        
        addSwipeGesture()
        
    }
    
    
    func addSwipeGesture(){
        
        let swipeUppGesture = UISwipeGestureRecognizer(target: self, action: #selector(PopUpCore.onSwipeUpp))
        
        swipeUppGesture.direction = .up
        addGestureRecognizer(swipeUppGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(PopUpCore.onSwipeDown))
        
        swipeDownGesture.direction = .down
        addGestureRecognizer(swipeDownGesture)
        
        
    }
    
    
    func onSwipeUpp(){
     
        directionInSign = 1
        onX()
    }
    
    func onSwipeDown(){
    
        directionInSign = -1
        onX()
    }
    
    
    @IBAction func onX(){

        let newFarme = CGRect(x: self.frame.origin.x,
                              y: -directionInSign * self.frame.height,
                              width:  self.frame.width,
                              height: self.frame.height)
        
        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.frame =  newFarme
            self.layer.opacity = 1.0
            self.bigButtonFade?.layer.opacity = 0.0
            
        }) { (_ animate : Bool) in
            
            self.bigButtonFade?.removeFromSuperview()
            self.bigButtonFade = nil
            self.removeFromSuperview()
        }
        
        
    }
    
}
