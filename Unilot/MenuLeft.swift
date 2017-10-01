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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("dsdfsdf")
    }

}
        
