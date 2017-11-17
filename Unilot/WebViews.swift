//
//  WebViews.swift
//  Unilot
//
//  Created by Alyona on 10/29/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

class IcoView : WebCore {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        let url_line =   "https://unilot.io/\(langCodes[current_language_ind])/"
        
        openPage(url_line)
    }
    

    override func setTitle() {

        navigationItem.title = TR("ICO")

    }
    
}

class FAQView : WebCore {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let url_line =   kServer + langCodes[current_language_ind] + "/mobile/faq"
 
        openPage(url_line)
    }
 
    override func setTitle() {
        
        navigationItem.title = TR("faq")
        
    }
}
