//
//  IcoView.swift
//  Unilot
//
//  Created by Alyona on 10/29/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

class IcoView : WebCore {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = kColorMenuPeach

        navigationItem.title = TR("ICO")
        
        let id_lang =   setting_strings[1].index(of: current_language)!
        
        let url_line =   "https://unilot.io/\(langCodes[id_lang])/"
        
        openPage(url_line)
        
        
    }
    
   
    
}

