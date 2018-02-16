//
//  MenuLeft.swift
//  Unilot
//
//  Created by Alyona on 9/28/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit 
import MessageUI


class MenuLeft: UITableViewController, SWRevealViewControllerDelegate , MFMailComposeViewControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var itemBadge: SpecialItem!
    @IBOutlet weak var ico_image: UIImageView!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var how: UILabel!
    @IBOutlet weak var wp: UILabel!
    @IBOutlet weak var faq: UILabel!
    @IBOutlet weak var settings: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var feedback: UILabel!
    @IBOutlet weak var info: UILabel!

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
        
        profile.text = TR("profile")
        history.text = TR("history_of_drawings")
        settings.text = TR("settings")

        how.text = TR("how_it_works")
        wp.text = TR("wp")
        faq.text = TR("faq")
        info.text = "Version : " + current_api_version + "/" + current_build + " Closed Beta"
        ico_image.image = UIImage(named : TR("site"))
        ico_image.contentMode = .scaleAspectFit
        feedback.text  = TR("send_feedback")
        

    }
    
    //MARK: - TableVIew
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowOneHeight = CGFloat(45)
        
        switch indexPath.section {
        case 0: // header
            return rowOneHeight
//            return min(CGFloat(tableView.frame.height - rowOneHeight * 10.5), rowOneHeight * 1.5 )

        case 1: // 6 main buttons
            if indexPath.row == 3 {
                return 10
            } else {
                return rowOneHeight
            }

        case 2: // 1 ico button
            return rowOneHeight * 1.8

        case 3: // socials
            return rowOneHeight * 1.4
        
        case 4: // static info
            return rowOneHeight * 1.3

        case 5: // feedback
            return rowOneHeight
            
            
        default: //
            
            return rowOneHeight
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var viewsNames : [[String]] = [
        
        ["SB_MainViewScroll"],
        
        [
         "SB_ProfileViewController",
         "SB_HistoryTable",
         "SB_SettingsView",
         kEmpty,
         "SB_HowDoesItWork",
         "SB_WPView",
         "SB_FAQ"],
        
        ["SB_IcoView"],
 
        [kEmpty],
        
        [kEmpty],

        ["feed_back"]

        ]
        
        let nameOfView = viewsNames[indexPath.section][indexPath.row]
        
        if nameOfView == "SB_HowDoesItWork" {
            revealViewController().revealToggle(animated: true)
            current_controller_core?.onTutorialWithButton()
        } else {
           
            if nameOfView == "feed_back" {

                onFeedBack()
                
            } else
            
            if nameOfView != kEmpty{
                goToViewController(nameOfView)
            }
        }
        
    }

    
    //MARK: - Actions
    
    @IBAction func onSocial(_ sender : UIButton){
        
        let link_tag = sender.tag / 100 - 1
        
        let links = [kLink_FB, kLink_Telegram, kLink_Reddit, kLink_Twitter, kLink_Medium]
 
        sendEvent(kEVENT_menuLeft[link_tag])
        
        openUrlFromApp(links[link_tag] )
        
    }
    
    func onFeedBack(){
        
        SweetAlert().showAlert(" " , subTitle: TR("send_feedback_text"), style: AlertStyle.warning, buttonTitle: TR("No"),
                               buttonColor: UIColor.colorFromRGB(0xDD6B55) ,
                               otherButtonTitle: TR("Yes"),
                               otherButtonColor: kColorNormalGreen )
        { (isOtherButton) -> Void in

                                if isOtherButton == true {
                                    
                                }
                                else {
                                    self.sendLetter()
                                }
        }
        
    }
    
    func sendLetter(){
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.delegate = self
            mail.mailComposeDelegate = self
            mail.setToRecipients([kFeedBackMail])
            mail.setSubject(TR("send_feedback_header"))
//            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
            
        } else {
            // show failure alert
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
    
    //MARK: - mailComposeControllerDelegate
 
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }

    //MARK: - SWRevealViewControllerDelegate
    
 
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        
 
    }

    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {        
        current_controller_core?.view.endEditing(true)
    }
    
    
}

