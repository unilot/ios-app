//
//  TextViewController.swift
//  Unilot
//
//  Created by Alyona on 10/8/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class TextViewController : ControllerCore {
        
    @IBOutlet weak var textView : UITextView!
    
    
    
    override func addParallaxToView() {
        
        
    }
    
    override func clearNavBar(){
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setMenuButton()
        
  
        navigationItem.title = TR("Terms of use")

        textView.text =  " "
        
//        showActivityViewIndicator()

    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addText()
     
//        hideActivityViewIndicator()
    }
   
    
    func setMenuButton(){
        
        let imageItem = setColorForImage(CGSize(width: 30, height: 30), "menu")
        let backItem = UIBarButtonItem(customView: imageItem)
        //        backItem.title = nil
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = backItem
        
        if let nav = (navigationController as? NavigationController ) {
            nav.initNavigationData(backItem)
        }
    }
    
    func addText() {
        
        if let filepath = Bundle.main.path(forResource: "Terms", ofType: "html") {
            do {
                let contents = try String(contentsOfFile: filepath)
                
                let theAttributedString = try! NSAttributedString(data: contents.data(using: String.Encoding.utf8, allowLossyConversion: false)!,
                                                                  options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                                  documentAttributes: nil)
                
                textView.attributedText = theAttributedString
                
            } catch {
                // contents could not be loaded
            }
        }
        
    }

}
    
