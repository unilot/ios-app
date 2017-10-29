//
//  IcoView.swift
//  Unilot
//
//  Created by Alyona on 10/29/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class IcoView : ControllerCore , UIWebViewDelegate{
    
    @IBOutlet weak var webView : UIWebView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationItem.title = TR("ICO")        
        
    }
    
    
    
    
    //MARK: - unSignedRequest
    
    func unSignedRequest ( ) {
        
        let index = setting_strings[1].index(of: current_language)!
        
        let urlRequest =  URLRequest.init(url: URL.init(string: "https://unilot.io/\(langCodes[index])/")!)
        
        webView.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
//        
//        let requestURLString = (request.url?.absoluteString)! as String
//        
//        if requestURLString.hasPrefix("redirect_back") {
////            let range: Range<String.Index> = requestURLString.range(of: "code=")!
////            handleAuth(requestURLString.substring(from: range.upperBound))
//            return false
//        }
        return true
    }
//    
//    func handleAuth(_ code: String)  {
//        
//    }
    
    
    
    //MARK: - DELEGATE
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)

    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        
        showActivityViewIndicator()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        
        hideActivityViewIndicator()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        
        webViewDidFinishLoad(webView)

    }

}

