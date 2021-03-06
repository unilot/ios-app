//
//  LoadingView.swift
//  Unilot
//
//  Created by Alyona on 10/13/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

class RightNavigationController : UINavigationController{
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    
        let rootViewController : UIViewController!
        
        rootViewController = getVCFromName("SB_MainViewScroll")
        
        self.setViewControllers([rootViewController], animated:  true)
    }
    
}

class LoadingView : ControllerCore{
    
    @IBOutlet weak var fon: UIImageView!

    
    override func viewDidLoad() {


        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
 
        super.viewWillAppear(animated)
        
//        showActivityViewIndicator()
        
        if startWas {
            
            getSessionToken()
            
        } else {
            
            init_notification_start()

        }
        
    }

    
    override func popViewWasClosed(){
 
        goToMainController()

    }
    

    
    //MARK: - STEPS TO ENTER APP
    
    @objc func getSessionToken(){
        
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
                
                self.getWalletsInfo()

            }
            
        }
    }
    

    func getWalletsInfo(){
 
        guard (users_account_wallets.count > 0) && (games_list.count > 0) else
        {
            prepereToEnter()
            return
        }
        
        NetWork.getWalletsOfUserInGames(completion: { (error : String?) in
            
            if error != nil {
                
                self.failComplete(error!)
                
            } else {
                
                self.prepereToEnter()
                MemoryControll.saveWalletsInMemory()
            }
            
        })
        
    }
    
    //MARK: - Prepere to Enter

    func prepereToEnter(){
        
        if open_from_notif == default_first_launch {
            
            openTutorialFirst()
            
            UIView.animate(withDuration: 0.6, animations: {
                
                self.fon.layer.opacity = 0.0
                
            })
            
        } else {
            
            enterTheApp()
        }
        
        
    }
    
    func enterTheApp(){
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.fon.layer.opacity = 0.0
            
        }) { (_ sender : Bool) in
            
            NetWork.postDeviceSettings()
            
            self.goToMainController()
            
            
        }
        
        
    }
    
    
    //MARK: - STUUFF

    
    func failComplete(_ error: String!){
 
        showError(error)
 
        if let dataParse = MemoryControll.getObject("list_games") {
            _ = NetWork.parseGamesList(dataParse)
        }

        prepereToEnter()
        
    }
    
    func init_notification_start(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoadingView.getSessionToken),
                                               name: NSNotification.Name(rawValue: "enter_after_start"),
                                               object: nil)
    }
    
    func goToMainController(){

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
    
    
    override func onActiveAppNotifRecieved(_ notif : NotifStruct){
        
//        print("nothing happened")
        
    }
    
}

