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

    weak var pop_up_view : PopUpCore?
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()

    //MARK: - NOTIFICATION

    
    func onCheckAppNotifRecieved(){
        
        let int_type = Int(NotifApp.getDataFromNotifString(open_from_notif,2))
        
        goToMainViewFromType(int_type)
      
    }
    
    func onActiveAppNotifRecieved(_ notif : NotifStruct){
   
        playStandart()

        if notif.action == kActionCompleted {
 
            goToMainViewFromType(notif.game.type)

        } else {
            

            NotifApp.showLocalNotifInApp(withController: navigationController!, notif)
             
        }
        
    }
    
    
    //MARK:  -
    
    func onUserCloseView(){
        
        // hide popUps
        pop_up_view?.onX(0)

    }

    func onUserOpenView(){

    
    }
    
    //MARK: override
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

        UINavigationBar.appearance().tintColor = kColorSoftGray
       
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]

        setNeedsStatusBarAppearanceUpdate()
        
        addSwipeForMenuOpen()

        setNavControllerClear()

        setBackButton()
        
        setTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.isUserInteractionEnabled = true
        
        current_controller_core = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        hideActivityViewIndicator()
        
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: itemBadge!)
 
    }
    
    func  addInfoButton(){
        
        let infoB = UIBarButtonItem(image: UIImage(named:"info2-x3"), style: .plain,
                                       target: self,
                                       action: #selector(ControllerCore.onInfoBarButton(_:)) )
        
        infoB.tintColor =  kColorLightGray
        
        navigationItem.rightBarButtonItem = infoB
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
        
        navigationItem.titleView = image
        
    }


    func addSwipeForMenuOpen(){

        if navigationController?.revealViewController() != nil {
            navigationController?.view.addGestureRecognizer(navigationController!.revealViewController().panGestureRecognizer())
        }
    } 
    
    
    //MARK: - Go To Main View

    func goToMainViewFromType(_ type : Int?){
        
        let typeId = getTabBarTag(type)
        
        goToMainView(typeId)
    }
    
    
    func goToMainView(_ toTabBar : Int){
        
        let navController = self.navigationController!
        
        let rootViewController = getVCFromName("SB_MainViewScroll") as! MainViewScroll
        rootViewController.current_page = toTabBar
        
        
        var cntrllrs =   navController.viewControllers
        cntrllrs.insert(rootViewController, at: 0)
        
        navController.setViewControllers(cntrllrs, animated: true)
        navigationController?.popToViewController(rootViewController, animated: true)
    }
    
    func goToFAQ( ){
        
        let rootViewController = getVCFromName("SB_FAQ")
        
        navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    
    //MARK: - Settings

    func setFon(){
        
        let fon  = create_fon_view(self.view.frame.size)
        self.view.insertSubview(fon, at: 0)
        
    }
    
    
    func setBadgeNumber(){
        
        itemBadge?.setNumberLabel(notification_data.count)

    }
    //MARK: - On Functions
    
    @IBAction func onGoToAppStore(){
        
        openUrlFromApp(kLink_AppStore)
    }
    
    @IBAction func onInfoBarButton(_ sender: UIBarButtonItem){
         
        openTutorialFirst()
        
//        openInfoText()
    }
    
    func onOpenMenu(){
        navigationController?.popViewController(animated: true)
    }
    
    func openInfoText(){
        let viewWithPlaces = InfoView.createInfoView()
        pop_up_view = viewWithPlaces 
        viewWithPlaces.initView(mainView: self.view,  directionSign: -1)

    }

    func openHistory(_ sender : PopUpCore){
        
        sender.onX(0)
        
        let rootViewController = getVCFromName("SB_Details")

        navigationController?.pushViewController(rootViewController, animated: true)
        
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

    
    //MARK: - tutorial
     
    func openTutorialFirst(){
        
        let viewWithPlaces = TutorialScroll.createTutorialScroll()
        pop_up_view = viewWithPlaces
        
        let frameForView = CGRect(x: 0, y: 20,
                                  width: view.frame.width,
                                  height: view.frame.height-20)
        
        viewWithPlaces.initView(mainView: self.view, directionSign: 0, frameForView)
        
        
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
    
    
    //MARK: - delegates

    func popViewWasClosed(){
        
        
    }
    
    
    //MARK: - animateView
 
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

    
    func close_views(){
        
        let rootViewController = getVCFromName("SB_NeedNewVersion")

        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
 
        appDelegate.window!.rootViewController = rootViewController
        
        
    }
}
