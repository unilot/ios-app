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
    
    let rowOneHeight = CGFloat(50)
    @IBOutlet weak var itemBadge: SpecialItem!

    
    @IBOutlet weak var ico_image: UIImageView!

    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var how: UILabel!
    @IBOutlet weak var wp: UILabel!

    @IBOutlet weak var settings: UILabel!

    @IBOutlet weak var socials: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()
         
        self.view.backgroundColor = kColorMenuFon
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        itemBadge.setNumberLabel(badge_data["badge"]!)
        ico_image.image = UIImage(named : TR("Скоро"))
        ico_image.contentMode = .scaleAspectFit
        
        history.text = TR("История розыгрышей")
        how.text = TR("Как это работает")
        wp.text = TR("White paper")
        settings.text = TR("Настройки")
        socials.text = TR("Оставайтесь в курсе")
    }
     
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
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

    
    
    @IBAction func onSocial(_ sender : UIButton){
        
        
        var url = URL(string: "https://www.google.com")


        switch sender.tag {
        case 100:
            url = URL(string: kLink_FB)
        case 200:
            url = URL(string: kLink_Telegram)
        case 300:
            url = URL(string: kLink_Reddit)
        case 400:
            url = URL(string: kLink_Twitter)
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
    
 
    
    func goToViewController(_ nameOfView : String){
        
        let navController = UINavigationController()
        let rootViewController = getVCFromName(nameOfView)
        
        
        var cntrllrs =   navController.viewControllers
        cntrllrs.insert(rootViewController, at: 0)
        
        navController.setViewControllers(cntrllrs, animated: false)
        revealViewController().pushFrontViewController(navController, animated: true)
     }
}

