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

    let transition = PopAnimator()
    
    weak var barCodeResonder : PopUpCore?

    
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

    
    func closeAllPopUps(){
        
        for item in pop_up_view {
            item.onX(0)
        }
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

        navigationController?.navigationBar.isHidden = false
        
        setNeedsStatusBarAppearanceUpdate()
        
        addSwipeForMenuOpen()

        setNavControllerClear()

        setBackButton()
        
        setTitle()
        
        transition.dismissCompletion = {

        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.isUserInteractionEnabled = true
        
        current_controller_core = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        closeAllPopUps()

        hideActivityViewIndicator()
        
        super.viewWillDisappear(animated)
        
        self.view.isUserInteractionEnabled = false
        

        
    }
    //MARK: - Buttons
   
    func addProfileButton() {
        
        let frameBarButton = CGSize(width: 30, height: 30)
        
        itemBadge = setColorForImage(frameBarButton, "`profile-x3")
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.addTarget(self, action: #selector(ControllerCore.onPopUpProfile(_:)) , for: .touchUpInside)
        button.addSubview(itemBadge!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView:button)
        
    }
    
    func addMenuButton() {
      
        let frameBarButton = CGSize(width: 20, height: 20)
 
        itemBadge = setColorForImage(frameBarButton, "menu")
 
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.addTarget(self, action: #selector(ControllerCore.onRevealMenu) , for: .touchUpInside)
        button.addSubview(itemBadge!)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:button)
  
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
    
    func setProfileViewFirst(){
 
        let rootViewController = getVCFromName("SB_ProfileViewController")
        
        var cntrllrs =   navigationController!.viewControllers
        cntrllrs.insert(rootViewController, at: 0)
        
        navigationController!.setViewControllers(cntrllrs, animated: true)
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
    
    @IBAction func onInfoBarButton(){
    
        onTutorialWithButton()

    }
    
    
    
    func onShowWalletsAlert(){
        
        if pop_up_upper_view != nil {
            return
        }
 
        let viewWithPlaces = WalletsAlert.createWalletsAlert()
        viewWithPlaces.delegate = current_controller_core
        viewWithPlaces.initView(mainView: self.view, directionSign: 1)
        
        sendEvent("EVENT_WALLETS_ALERT")
        
    }
    
    
    func onTutorialWithButton(){
        
        sendEvent("EVENT_TUTORIAL_VIEW")
        
        openTutorialFirst()
    }
    
    func onOpenMenu(){
        navigationController?.popViewController(animated: true)
    }
    
    func openInfoText(){
 
        if pop_up_upper_view != nil {
            return
        }
        
        let viewWithPlaces = InfoView.createInfoView()
        pop_up_view.append(viewWithPlaces)
        viewWithPlaces.initView(mainView: self.view,  directionSign: -1)

    }

    func openHistory(_ sender : PopUpCore){
        
        sender.onX(0)
        
        let rootViewController = getVCFromName("SB_Details")

        navigationController?.pushViewController(rootViewController, animated: true)
        
    }
    

   @objc func onRevealMenu(){
        
        if revealViewController() != nil {
            revealViewController().revealToggle(nil)
        }
        
    }
    
    @IBAction func onBackMenuArrow(){
     
        goToMainView(0)
    }

    @IBAction func onPopUpProfile(_ exitWithPlayAction : Bool = false){
        
        let profileController = getVCFromName("SB_ProfileViewController") as! ProfileViewController
        exitAsPopUp = exitWithPlayAction ? 2 : 1
        profileController.transitioningDelegate = self
       
        
        present(profileController, animated: true) {
            
        }
    }
    
    func onOpenTakePartView(){

    }
    
    @IBAction func onQRScan(_ sender: Any) {
 
//        if pop_up_upper_view != nil {
//            return
//        }
        
        let viewWithPlaces = ScannerViewController.create()
        viewWithPlaces.delegate = current_controller_core

        viewWithPlaces.initView(mainView: current_controller_core!.view, directionSign: 1)
        
        
    }
    
    
    
    func onQRAnswer(_ haveText : String?){
   
        barCodeResonder?.onQRAnswer(haveText)
    }

    
    //MARK: - tutorial
     
    func openTutorialFirst(){
 
        if pop_up_upper_view != nil {
            return
        }
        
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
    
    @objc func handleViewTap(recognizer: UIGestureRecognizer) {
        
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

extension ControllerCore: UIViewControllerTransitioningDelegate {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
           
            
        }, completion: nil)
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let heightV = view.frame.height * 0.05
        let widthV =  view.frame.width * 0.05
        transition.originFrame = CGRect(x: view.frame.width - widthV - 15 - 20,
                                        y: getStatusbarShift() + 20 , width: widthV, height: heightV)
        
        transition.presenting = true
 
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}



