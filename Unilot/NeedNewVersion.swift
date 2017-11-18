//
//  NeedNewVersion.swift
//  Unilot
//
//  Created by Alyona on 11/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import Crashlytics

class NeedNewVersion : ControllerCore {

    @IBOutlet weak var center_label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setNavControllerClear()
        
        setTitle()
        
        setFon()
    }
    
    
    override func setTitle() {
        
        center_label.text = String(format: TR("notification_old_version"), app_name)
        
        button.setTitle(TR("go_to_appstore"), for: .normal)

    }
    

    
    
    //MARK:  -
    
    override func onUserCloseView(){
        
        
    }
    
    override func onUserOpenView(){
        
        
    }
    
    //MARK: - NOTIFICATION
  
    
    override func onActiveAppNotifRecieved(_ notif : NotifStruct){
        
 
        
    }
    
    
}
