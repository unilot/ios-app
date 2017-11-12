//
//  MenuLeft.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import NVActivityIndicatorView



class MenuLeft: UITableViewController, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var itemBadge: SpecialItem!
    @IBOutlet weak var ico_image: UIImageView!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var how: UILabel!
    @IBOutlet weak var wp: UILabel!
    @IBOutlet weak var settings: UILabel!
    @IBOutlet weak var socials: UILabel!

    
    //MARK: - View override

    override func viewDidLoad() {

        super.viewDidLoad()
        
        setNavControllerClear()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setLocolizedStuff()
    }
    
    
    //MARK: -
    
    func setLocolizedStuff(){
        
        itemBadge.setNumberLabel(notification_data.count)
        
        history.text = TR("history_of_drawings")
        how.text = TR("how_it_works")
        wp.text = TR("presentation")
        settings.text = TR("settings")
        socials.text = TR("stay_tuned:")
        
        ico_image.image = UIImage(named : TR("soon"))
        ico_image.contentMode = .scaleAspectFit

    }
    
    //MARK: - TableVIew
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowOneHeight = CGFloat(50)
        
        switch indexPath.section {
        case 0: // header
            return rowOneHeight * 2

        case 1: // 3 main buttons
            return rowOneHeight
            
        case 2: // 1 settings
            return rowOneHeight * 1.5

        case 3: // 1 ico button
            return rowOneHeight * 2

        default: // socials
            return CGFloat(tableView.frame.height - rowOneHeight * 8.5)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var viewsNames = [
        
        ["SB_TabBarController"],
        
        ["SB_HistoryTable",
         "SB_HowDoesItWork",
         "SB_WhitePapersView"],
        
        ["SB_SettingsView"],
        
        ["SB_IcoView"],

        [nil]

        ]
     
            
        if let nameOfView = viewsNames[indexPath.section][indexPath.row]{
            goToViewController(nameOfView)
        }
    }

    
    //MARK: - Actions
    
    @IBAction func onSocial(_ sender : UIButton){
        
        let links = [kLink_FB, kLink_Telegram, kLink_Reddit, kLink_Twitter]
 
        openUrlFromApp(links[sender.tag / 100 - 1] )
        
    }
 
    
    func goToViewController(_ nameOfView : String){
        
        let navController = UINavigationController()
        let rootViewController = getVCFromName(nameOfView)
        
        var cntrllrs =   navController.viewControllers
        cntrllrs.insert(rootViewController, at: 0)
        
        navController.setViewControllers(cntrllrs, animated: false)
        revealViewController().pushFrontViewController(navController, animated: true)
     }
    
    //MARK: - SWRevealViewControllerDelegate
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        
        
    }
}

