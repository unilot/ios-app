//
//  WebCore.swift
//  Unilot
//
//  Created by Alyona on 10/29/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import NVActivityIndicatorView


class WebCore : ControllerCore , UIWebViewDelegate{
    
    @IBOutlet weak var webView : UIWebView!
 
    
    func openPage(_ path :String){
        
        let url_line =  URL(string: path )

        webView.loadRequest(URLRequest(url:  url_line ?? URL(string:"ya.ru")!))
        
        webView.delegate = self
    }
    
    //MARK: - unSignedRequest
    
    
    func zooms(){
        
        webView.scalesPageToFit = true
        webView.scrollView.maximumZoomScale = 20; // set as you want.
        webView.scrollView.minimumZoomScale = 1; // set as you want.

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
    
    func handleAuth(_ code: String)  {
        
    }
    
    
    
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

