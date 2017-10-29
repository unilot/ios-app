//
//  WhitePapersView.swift
//  Unilot
//
//  Created by Alyona on 10/8/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//



import UIKit

class WhitePapersView : WebCore {
    
    override func viewDidLoad() {
        
        navigationItem.title = TR("White Papers")
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = kColorMenuPeach
        
        
        let id_lang =   setting_strings[1].index(of: current_language)!
        
        let file_line =   "UNILOT_\(langCodes[id_lang])"

        if let pdf = Bundle.main.url(forResource: file_line, withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
        
        zooms()
    }
    
    
    
}
