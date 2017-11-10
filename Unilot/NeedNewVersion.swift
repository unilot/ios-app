//
//  NeedNewVersion.swift
//  Unilot
//
//  Created by Alyona on 11/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


class NeedNewVersion : ControllerCore {

    
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = kColorMenuPeach
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.orange]
        
        setNavControllerClear()
        
        setTitle()
        
        title.text = TR("Обновите версию приложения")
        button.
        
    }
    
    
    
    @IBAction func onGoToAppStore(){
       
        
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
