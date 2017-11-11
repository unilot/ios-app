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
        
        navigationItem.title = TR("presentation")
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = kColorMenuPeach
        
        
        if let pdf = getAddressForFile() {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
        
        zooms()
    }
    
    
    func getAddressForFile() -> URL? {
        
        let file_line =   "UNILOT_\(langCodes[current_language_ind])"
        
        return Bundle.main.url(forResource: file_line, withExtension: "pdf", subdirectory: nil, localization: nil)
        
        
//        let url = URL(string: kPDF_files[id_lang])
        
//        return url

    }
    
    @IBAction func onShare(){
        
        if let link = getAddressForFile() {
            let objectsToShare = [link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
         
        
    }
    
}
