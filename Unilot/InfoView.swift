//
//  InfoView.swift
//  Unilot
//
//  Created by Alyona on 10/12/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit



class InfoView: PopUpCore {
    
    @IBOutlet weak var textView: UITextView!

    
    class func createInfoView() -> InfoView {
        let myClassNib = UINib(nibName: "InfoView", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! InfoView
    }
    
    
    override func setInitBorders(){
        
        super.setInitBorders()
        
        titleMain.text = TR("Как это работает")
        
        let myFileUrl = Bundle.main.url(forResource: TR("HDIW"), withExtension: "txt")
        let text = try! String(contentsOf: myFileUrl!, encoding: String.Encoding.utf8)
        
        textView.text = text
    }
    
}
