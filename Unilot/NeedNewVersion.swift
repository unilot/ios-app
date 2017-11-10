//
//  NeedNewVersion.swift
//  Unilot
//
//  Created by Alyona on 11/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


class NeedNewVersion : ControllerCore {

    @IBOutlet weak var center_label: UILabel!
    @IBOutlet weak var button: UIButton!

//    SB_NeedNewVersion
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = kColorMenuPeach
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.orange]
        
        setNavControllerClear()
        
        setTitle()
        
        center_label.text = TR("Обновите версию приложения")
        
        button.setTitle(TR("go to app store"), for: .normal)
        
        setFon()
    }
    
    
    func setFon(){
        
        let fon  = create_fon_view(self.view.frame.size)
        self.view.insertSubview(fon, at: 0)
        
    }
    
    @IBAction func onGoToAppStore(){
       
        openUrlFromApp(kLink_AppStore)
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
