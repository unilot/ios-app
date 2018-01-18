//
//  MenuLeft.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit 


class MenuLeft: UITableViewController, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var itemBadge: SpecialItem!
    @IBOutlet weak var ico_image: UIImageView!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var how: UILabel!
    @IBOutlet weak var wp: UILabel!
    @IBOutlet weak var faq: UILabel!
    @IBOutlet weak var settings: UILabel!
    @IBOutlet weak var socials: UILabel!

    
    //MARK: - View override

    override func viewDidLoad() {

        super.viewDidLoad()
        
        setNavControllerClear()
        
        revealViewController().delegate = self
    
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
        wp.text = TR("wp")
        faq.text = TR("faq")
        settings.text = TR("settings")
        socials.text = TR("stay_tuned:")
        
        ico_image.image = UIImage(named : TR("site"))
        ico_image.contentMode = .scaleAspectFit

    }
    
    //MARK: - TableVIew
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowOneHeight = CGFloat(45)
        
        switch indexPath.section {
        case 0: // header
            return rowOneHeight * 1.7
//            return min(CGFloat(tableView.frame.height - rowOneHeight * 10.5), rowOneHeight * 1.5 )

        case 1: // 4 main buttons
            return rowOneHeight
            
        case 2: // 1 settings
            return rowOneHeight * 1.7

        case 3: // 1 ico button
            return rowOneHeight * 2.5

        default: // socials
            
            return rowOneHeight * 5
                // CGFloat(tableView.frame.height - rowOneHeight * 9.5)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var viewsNames = [
        
        ["SB_MainViewScroll"],
        
        ["SB_HistoryTable",
         "SB_HowDoesItWork",
         "SB_WPView",
         "SB_FAQ"],
        
        ["SB_SettingsView"],
        
        ["SB_IcoView"],

        [nil]

        ]
     
        
            
        if let nameOfView = viewsNames[indexPath.section][indexPath.row]{
            
            if nameOfView == "SB_HowDoesItWork" {
                revealViewController().revealToggle(animated: true)
                current_controller_core?.onTutorialWithButton()
            } else {
                goToViewController(nameOfView)
            }
        }
    }

    
    //MARK: - Actions
    
    @IBAction func onSocial(_ sender : UIButton){
        
        let link_tag = sender.tag / 100 - 1
        
        let links = [kLink_FB, kLink_Telegram, kLink_Reddit, kLink_Twitter,
                     kLink_Steemit, kLink_Medium, kLink_LinkedIn, kLink_YouTube]
 
        sendEvent(kEVENT_menuLeft[link_tag])
        
        openUrlFromApp(links[link_tag] )
        
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

    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {        
        current_controller_core?.view.endEditing(true)
    }
    
    
}

