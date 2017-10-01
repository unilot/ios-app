//
//  WebView.swift
//  Unilot
//
//  Created by Alyona on 9/29/17.
//  Copyright © 2017 Vovasoft. All rights reserved.


import UIKit


class WebView : ControllerCore, UIWebViewDelegate {
    
    
    @IBOutlet weak var webView : UIWebView!
    
    var pageUrl : NSURL? = nil
    
    var pageTabName : String? = nil
    
    func setPage(_ pageUrlStr : String, _ pageName : String) {
        
        pageTabName = pageName
        
        pageUrl =  NSURL (string: pageUrlStr)
    }
    
    func showPage() {
        
        navigationItem.title =  TR(pageTabName)
        
        
        if let reliableUrl = pageUrl {
            
            let requestObj = NSURLRequest(url: reliableUrl as URL)
            
            webView.loadRequest(requestObj as URLRequest)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setPage("www.google.com", "unilot")
        
        navigationController!.navigationBar.backgroundColor = UIColor.white
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.clear
        
        
        webView.delegate = self
        
        showPage()
        
        showActivityViewIndicator()

    }
    
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        hideActivityViewIndicator()
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showActivityViewIndicator()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        hideActivityViewIndicator()
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
 
    
    
}

class TermsOfView : ControllerCore {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
    // MARK: - setInits
    
    func setInits(){
        
        let lblSwipe = self.view.viewWithTag(100) as! UITextView
        lblSwipe.isEditable = false
        lblSwipe.text = "\n  PROPRIETARY SERVICES FOR REGISTERED USERS. MHE operates an electronic platform/system that enables students, instructors, and administrators of educational institutions to access and use certain online products and services offered by MHE (the \"Services\") through the Site. The material on this Site includes general non-proprietary information available to all users of the Site, but in order to access and use the Services you will be required to register on the Site or through your educational institution. If you register to use the Services on behalf of your educational institution, you will be required to agree to additional terms and conditions in connection with the registration process (the \" Services Agreement\")."
        
    }
    
    @IBAction func onBack(){
        
        dismiss(animated: true, completion: nil)
        
        //        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func onAgree(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
