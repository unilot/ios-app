//
//  ControllerCore.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import AVFoundation
 
class ControllerCore: UIViewController, PopUpCoreDelegate {
    
    var dgActivityIndicatorView : DGActivityIndicatorView?

    var itemBadge: SpecialItem?

    var pop_up_view = [PopUpCore]()

    //MARK: - NOTIFICATION
 
    
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
//        pop_up_view?.onX(0)

    }

    func onUserOpenView(){

        if ( NotifApp.getDataFromNotifString(open_from_notif,0) == kActionCompleted) {
            
            let type = NotifApp.getDataFromNotifString(open_from_notif,2)
            
            goToMainViewFromType(Int(type))
        }
    
    }
    
    //MARK: override
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

        UINavigationBar.appearance().tintColor = kColorSoftGray
       
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]

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
 
        itemBadge = setColorForImage(frameBarButton, "menu")
 
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.addTarget(self, action: #selector(ControllerCore.onRevealMenu) , for: .touchUpInside)
        button.addSubview(itemBadge!)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:button)
  
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
        
        let image = setImageForTitle(CGSize(width: 102, height: 30), "unilotmenu-item")
        
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
    
        onTutorialWithButton()

    }
    
    func onTutorialWithButton(){
        
        sendEvent("EVENT_TUTORIAL_VIEW")
        
        openTutorialFirst()
    }
    
    func onOpenMenu(){
        navigationController?.popViewController(animated: true)
    }
    
    func openInfoText(){
        let viewWithPlaces = InfoView.createInfoView()
        pop_up_view.append(viewWithPlaces)
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
        
        let viewWithPlaces = ScannerViewController.create()
        viewWithPlaces.delegate = current_controller_core

        viewWithPlaces.initView(mainView: current_controller_core!.view, directionSign: 1)
        
        
    }
    
    
    
    func onQRAnswer(_ haveText : String?){
   
        
    }

    
    //MARK: - tutorial
     
    func openTutorialFirst(){
        
        let viewWithPlaces = TutorialScroll.createTutorialScroll()
        pop_up_view.append(viewWithPlaces)
        viewWithPlaces.hideMore = (open_from_notif == default_first_launch)

        viewWithPlaces.delegate = self
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let frameForView = CGRect(x: 0, y: 0,
                                  width: view.frame.width,
                                  height: view.frame.height)
        
        viewWithPlaces.initView(mainView: view, directionSign: -1, frameForView)
        
        
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
 
        if dgActivityIndicatorView == nil {
            dgActivityIndicatorView = DGActivityIndicatorView.init(type: .cookieTerminator, tintColor: kColorHistoryGray, size: 40)
            dgActivityIndicatorView?.center = view.center
            view.addSubview(dgActivityIndicatorView!)

        }
        
        dgActivityIndicatorView!.startAnimating()
        
        
    }

    func hideActivityViewIndicator(){

        dgActivityIndicatorView?.stopAnimating()
        dgActivityIndicatorView?.removeFromSuperview()
        dgActivityIndicatorView = nil
         
    }
    
    
    
    


    
    
    func showError(_ error : String) {

        _ = SweetAlert().showAlert(" ", subTitle: error, style: .error, buttonTitle: TR("OK"), buttonColor: kColorNormalGreen, action: nil)

    }
    
    
    //MARK: - delegates

    func popViewWasClosed(){
        
        
    }
    
    func refreshAllViews(){
        
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

