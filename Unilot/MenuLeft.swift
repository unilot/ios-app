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
    
    
    let rowHeight = CGFloat(40)
    
    let rowOneHeight = CGFloat(80)

    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        UIApplication.shared.statusBarStyle = .lightContent
   
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 0 {
            if indexPath.section == 0 {
                return rowOneHeight
            } else {
                return  CGFloat(tableView.frame.height -  rowHeight * 5 - rowOneHeight)
            }
        }
    
        return rowHeight
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

}
        
