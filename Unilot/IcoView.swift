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
        
        let url_line =   "https://unilot.io/\(langCodes[current_language_ind])/"
        
        openPage(url_line)
        
        
    }
    
   
    
}

