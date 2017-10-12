//
//  InfoView.swift
//  Unilot
//
//  Created by Alyona on 10/12/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit



class InfoView: UIView {
  
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    
    class func createInfoView() -> InfoView {
        let myClassNib = UINib(nibName: "InfoView", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! InfoView
    }
    
    
    func initView(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = kColorLightGray.cgColor
        self.layer.shadowRadius = 2
        
        
    }
    
     
    @IBAction func onX(){
        UIView.animate(withDuration: 0.4, animations: {
            self.frame = CGRect(x: 10,
                                y: self.frame.height,
                                width: self.frame.width,
                                height: self.frame.height)
            self.layer.opacity = 0.0
        }) { (animate : Bool) in
            self.removeFromSuperview()
        }
        
    }
    
}
