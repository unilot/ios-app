//
//  TextViewCore.swift
//  Unilot
//
//  Created by Alyona on 10/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class TextViewCore : ControllerCore {
    
    @IBOutlet weak var textView : UITextView!
    
    var file_name = ""

    var view_name = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        textView.text = " "
        
    }
    
    override func setTitle() {
        navigationItem.title = TR(view_name)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addText()
        
//                hideActivityViewIndicator()
    }
    
    func addText() {
        
        if let filepath = Bundle.main.path(forResource: file_name, ofType: "html") {
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

