//
//  LoadingView.swift
//  Unilot
//
//  Created by Alyona on 10/13/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SCLAlertView

class LoadingView : UIViewController, NVActivityIndicatorViewable{
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        
        startAnimating(CGSize(width: 40 , height: 40),
                       type : NVActivityIndicatorType.lineScalePulseOut)
     
        
        MemoryControll.init_defaults_if_any()
        
//        NetWork.test()
        getSessionToken()

//        getGamesList()
        
    }
    
    func failComplete(_ error: String){
        
        stopAnimating()
//        SCLAlertView().showError(" ", subTitle: error)
        enterTheApp()

    }
    
    
    func enterTheApp(){
        
        stopAnimating()
        
        let view_controller_1 = getVCFromName("SB_SWRevealViewController")
        present(view_controller_1, animated: false, completion: nil)
//        performSegue(withIdentifier: "start", sender: nil)
        
    }
    func getSessionToken(){
        
        NetWork.startSession { (error : String?) in
            
            if error != nil {
                
                self.failComplete(error!)
                
            } else {
                
                self.getGamesList()
            }
            
        }
    }
    
    
    func getGamesList(){
        
        NetWork.getGamesList { (error : String?) in
            
            if error != nil {

                self.failComplete(error!)
            
            } else {
                
                self.enterTheApp()

            }
            
        }
    }
    
    

    //MARK: - SCLAlertView
    
    
    
}

