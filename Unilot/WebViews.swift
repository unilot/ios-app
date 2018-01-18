//
//  WebViews.swift
//  Unilot
//
//  Created by Alyona on 10/29/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit



class WPView : WebCore {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sendEvent("EVENT_WHITE_PAPER")

        let url_line =   "https://unilot.io/\(langCodesSite[current_language_ind])/wp.html"
 
        openPage(url_line)
    }
    
    
    override func setTitle() {
        
        navigationItem.title = TR("wp")

    }
    
}


class IcoView : WebCore {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sendEvent("EVENT_ICO")

 
        let url_line =   "https://unilot.io/\(langCodesSite[current_language_ind])/"
        
        
        openPage(url_line)
    }
    

    override func setTitle() {

        navigationItem.title = TR("ICO")

    }
    
}

class FAQView : WebCore {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sendEvent("EVENT_FAQ")
        
        let url_line =   kServer + langCodes[current_language_ind] + "/mobile/faq"

        openPage(url_line)
    }
 
    override func setTitle() {
        
        navigationItem.title = TR("faq")
        
    }
}
