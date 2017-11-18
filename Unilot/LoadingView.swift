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


class LoadingView : ControllerCore{
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        MemoryControll.init_defaults_if_any()

    }
    
    override func viewWillAppear(_ animated: Bool) {
 
        super.viewWillAppear(animated)
        
        showActivityViewIndicator()
        
        if startWas {
            
            getSessionToken()
            
        } else {
            
            init_notification_start()

        }
        
    }
    
    
    func enterTheApp(){
        
        stopAnimating()
        
        goToMainController()

    }
    
    
    func getSessionToken(){
        
        NetWork.startSession { (error : String?) in
            
            if error != nil {
                
                self.failComplete(error!)
                
            } else {
                
                self.postNotifToken()
            }
            
        }
    }
    
    func postNotifToken(){
         
        NetWork.postNotifToken { (error : String?) in
            
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
    

    
    //MARK: - STUUFF

    
    func failComplete(_ error: String){
        
        stopAnimating()
        
        SCLAlertView().showError(" ", subTitle: error)
        
        if let dataParse = MemoryControll.getObject("list_games") {
            _ = NetWork.parseGamesList(dataParse)
        }
        
        enterTheApp()
        
    }
    
    func init_notification_start(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoadingView.getSessionToken),
                                               name: NSNotification.Name(rawValue: "enter_after_start"),
                                               object: nil)
    }
    
    func goToMainController(){

        NetWork.postDeviceSettings()

        present(getVCFromName("SB_SWRevealViewController"), animated: false, completion: nil)
   
    }


    //MARK: - End Of Version screen
    
    override func addSwipeForMenuOpen() {
        
    }
    
    override func setNavControllerClear(){
        
        
    }
    
    override func setBackButton(){
        
    }
    
    override func setTitle()  {
        
    }
    
    func onScreenNow(){
        
    }
    
    //MARK:  -
    
    override func onUserCloseView(){
        
        
    }
    
    override func onUserOpenView(){
        
        
    }
    
    //MARK: - NOTIFICATION
    
    
    override func onCheckAppNotifRecieved(){
        
        
    }
    
    override func onActiveAppNotifRecieved(_ notif : NotifStruct){
        
        
        
    }
    
}

