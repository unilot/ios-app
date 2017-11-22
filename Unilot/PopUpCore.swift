//
//  PopUpCore.swift
//  Unilot
//
//  Created by Alyona on 10/12/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


protocol PopUpCoreDelegate {

    func openHistory(_ sender : PopUpCore)
    func showActivityViewIndicator()
    func hideActivityViewIndicator()
    func showError(_ error : String)
    func popViewWasClosed()
    func onQRAnswer(_ haveText : String?)

}

class PopUpCore: UIView  {
    
    @IBOutlet weak var titleMain: UILabel!

    var current_game = local_current_game
    
    var delegate : PopUpCoreDelegate?
    var bigButtonFade : UIButton?
    var directionInSign = CGFloat(1)
    
    func setInitBorders(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = kColorLightGray.cgColor
        
    }
    
    //MARK: - actions
    

    func initView(mainView: UIView, directionSign: CGFloat, _ frameCustom : CGRect? = nil){
        
        self.layoutIfNeeded()
        
        self.tag = kTag_PopUp
        
        directionInSign = directionSign
        
        let frameView =  frameCustom ??
            CGRect(x: 10,   y: 70, width:  mainView.frame.width - 20, height:  mainView.frame.height - 130)
        
        
        bigButtonFade = UIButton(frame: mainView.frame)
        bigButtonFade!.backgroundColor = UIColor.black
        bigButtonFade!.addTarget(self, action: #selector(PopUpCore.onX(_:)), for: .touchUpInside)
        bigButtonFade!.layer.opacity = 0.0
        UIApplication.shared.keyWindow?.addSubview(bigButtonFade!)
        
        self.layer.opacity = 0.0
        self.frame = CGRect(x: frameView.origin.x,
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
    
    
    @IBAction func onXbutton() {
        
        onX()
        
    }
    
    
    func onX(_ duration: Double = 0.4){

        onWideX(duration)
    }
    
    func onWideX(_ duration: Double = 0.4, _ completion : (() -> Void)? = nil){

        
        if duration > 0.0 {
            
            let newFarme = CGRect(x: self.frame.origin.x,
                                  y: -directionInSign * self.frame.height,
                                  width:  self.frame.width,
                                  height: self.frame.height)
            
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.frame =  newFarme
                self.layer.opacity = 0.0
                self.bigButtonFade?.layer.opacity = 0.0
                
            }) { (_ animate : Bool) in
                
                self.deleteSelf(animated:true)
                completion?()
            }
            
        } else {
            deleteSelf(animated:true)
            completion?()
        }
        
    }
    
    func afterDeleteSelf(){
        
    }
    func deleteSelf(animated : Bool){
        
        bigButtonFade?.removeFromSuperview()
        bigButtonFade = nil
        delegate?.popViewWasClosed()
        removeFromSuperview()
    }
    
    
 
}
