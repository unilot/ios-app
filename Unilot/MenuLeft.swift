//
//  MenuLeft.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class MenuLeft: UITableViewController {
    
    
    let rowOneHeight = CGFloat(30)

    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
   
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch indexPath.section {
        case 0: // header
            return rowOneHeight * 2

        case 1: // 3 main buttons
            return rowOneHeight
            
        case 2: // settings
            return rowOneHeight * 2

        default: // socials
            return CGFloat(tableView.frame.height - rowHeight * 7)
        }
        
    }
    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        
//        
//        switch indexPath.row {
//        case 0:
//            
//            print("sigue_unilot")
//
//            self.performSegue(withIdentifier: "sigue_unilot", sender: self)
//
//            break
//            
//        case 3 :
//            
//            
//            print("sigue_white")
//
//            self.performSegue(withIdentifier: "sigue_white", sender: self)
//            
//            break
//
//        case 2 :
//            
//            self.performSegue(withIdentifier: "sigue_white", sender: self)
//
//            break
//            
//            
//        default:
//            break
//        }
//    }

    
    
    @IBAction func onSocial(_ sender : UIButton){
        
        
        var url = URL(string: "https://www.google.com")

        
        switch sender.tag {
        case 100:
            url = URL(string: "https://www.facebook.com")
        case 200:
            url = URL(string: "https://www.telegram.com")
        case 300:
            url = URL(string: "https://www.instagram.com")
        case 400:
            url = URL(string: "https://www.twitter.com")
        default:
            break
        }
        
        
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })

            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url!)
            }
        }
        
    }
    
    
}

