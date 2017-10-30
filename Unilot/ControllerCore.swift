//
//  ControllerCore.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import AVFoundation
import NVActivityIndicatorView
import SCLAlertView
import QRCodeReader


class ControllerCore: UIViewController, NVActivityIndicatorViewable, PopUpCoreDelegate {

    
    var activityIndicatorView : NVActivityIndicatorView?
    var itemBadge: SpecialItem?

    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    func addNotifAction(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ControllerCore.onNotifRecieved),
                                               name: NSNotification.Name(rawValue: "NOTIFICATION_CAME"),
                                               object: nil)
    }
    
    func onNotifRecieved(){
        
        UserNotifications.notificationAction()
    }
    
    //MARK: override
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = kColorMenuPeach
       
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.orange]

        addNotifAction()

        addSwipeForMenuOpen()

        setNavControllerClear()

        setBackButton()
        
        setTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.isUserInteractionEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.view.isUserInteractionEnabled = false
        
    } 
    //MARK: - Buttons
    
    
    func addMenuButton() {
        
        let frameBarButton = CGSize(width: 20, height: 20)
        
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(ControllerCore.onRevealMenu) )
         
        itemBadge = setColorForImage(frameBarButton, "menu")
        itemBadge!.addGestureRecognizer(tapRecognizer)
        
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: itemBadge!)
 
    }
    
    
    
    func setBackButton(){
        
        let backItem = UIBarButtonItem(image: UIImage(named:"arrow_back"), style: .plain,
                                       target: self,
                                       action: #selector(ControllerCore.onBackMenuArrow) )
        backItem.tintColor =  kColorLightOrange
        navigationItem.backBarButtonItem = backItem
        
        
    }
    
    func setTitle() {
        
        let image = setImageForTitle(CGSize(width: 100, height: 40), "unilotmenu-item")
        
        tabBarController?.navigationItem.titleView = image
        
    }

    
    func addSwipeForMenuOpen(){

        if navigationController?.revealViewController() != nil {
            navigationController?.view.addGestureRecognizer(navigationController!.revealViewController().panGestureRecognizer())
        }
    } 
    
    func openHistory(_ sender : PopUpCore){
        
        sender.onX()
        
        let rootViewController = getVCFromName("SB_Details")

        navigationController?.pushViewController(rootViewController, animated: true)
        
    }
    
    
    func goToMainView(_ toTabBar : Int){
        
        let navController = self.navigationController!
         
        let rootViewController = getVCFromName("SB_TabBarController") as! TabBarController
        rootViewController.selectedIndex = toTabBar

        
        var cntrllrs =   navController.viewControllers
        cntrllrs.insert(rootViewController, at: 0)
        
        navController.setViewControllers(cntrllrs, animated: true)
        navigationController?.popViewController(animated: true)
    }
 
    
    func onRevealMenu(){
        if revealViewController() != nil {
            revealViewController().revealToggle(nil)
        }
    }
    
    @IBAction func onBackMenuArrow(){
     
        goToMainView(0)
    }

    @IBAction func onQRScan(_ sender: Any) {
         
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            
            self.onQRAnswer( result?.value)
           
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    func onQRAnswer(_ haveText : String?){
   
        
        
        
    }

    //MARK: -  NetWork
    
    func onAnswerSuccess(_ dataRecieved : [[String: String]]){
 
    }
    
    func onAnswerError(_ error_line : String?){
        
        
        
    }
    
    //MARK: - keyboard

    
    func addTouchForKeyBoard(){
        
        let viewTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(ControllerCore.handleViewTap(recognizer:)))
        
        viewTapGestureRec.cancelsTouchesInView = false
        self.view.addGestureRecognizer(viewTapGestureRec)
        
    }
    
    func handleViewTap(recognizer: UIGestureRecognizer) {
        
            answerFromKeyBoardClosed()
        
    }
    
    func answerFromKeyBoardClosed(){
        
    }
    //MARK: - activityView

    func showActivityViewIndicator(){
        
        let size = CGSize(width: 40 , height: 40)

        startAnimating(size, type : NVActivityIndicatorType.lineScalePulseOut )
        
 
    }
    
    func hideActivityViewIndicator(){
        
        stopAnimating()
    }
    
    
    func showError(_ error : String) {
        SCLAlertView().showError(" ", subTitle: error)

    }
    //MARK: - onButtons
    
    
    func onOpenMenu(){
        navigationController?.popViewController(animated: true)
    }
 
    
    func animateAppearance(){
        
        if self.view.layer.opacity < 1.0 {
            UIView.animate(withDuration: 0.5) {
                self.view.layer.opacity = 1.0
            }
        }
        
    }
    
    
    func animateDisAppearance(){
        
        if self.view.layer.opacity > 0.0 {
            UIView.animate(withDuration: 0.5) {
                self.view.layer.opacity = 0.0
            }
        }
        
    }

}
