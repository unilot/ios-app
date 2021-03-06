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
        
        super.viewDidLoad()
        
        if let pdf = getAddressForFile() {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
        
        zooms()
    }
    
    override func setTitle() {
        
        navigationItem.title = TR("wp")
        sendEvent("EVENT_WHITE_PAPER")
    }

    
    func getAddressForFile() -> URL? {
        
//        let file_line =   "UNILOT_\(langCodes[current_language_ind])"
//
//        return Bundle.main.url(forResource: file_line, withExtension: "pdf", subdirectory: nil, localization: nil)
        
        return URL(string: kPDF_files[current_language_ind])
        
        
    }
    
    @IBAction func onShare(){
        
        if let link = getAddressForFile() {
            let objectsToShare = [link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
         
        
    }
    
}
