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


class ControllerCore: UIViewController, NVActivityIndicatorViewable {

    var activityIndicatorView : NVActivityIndicatorView?
 
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addSwipeForMenuOpen()

        setNavControllerClear()

        setTitle()
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
    
    
    
    func goToMainView(){
        
        let navController = self.navigationController!
        
        
        let rootViewController = getVCFromName("SB_TabBarController") as! TabBarController
        rootViewController.selectedIndex = currentTabBarLottery

        
        var cntrllrs =   navController.viewControllers
        cntrllrs.insert(rootViewController, at: 0)
        
        navController.setViewControllers(cntrllrs, animated: false)
        navigationController?.popViewController(animated: true)

        
        
    }
    
    @IBAction func onBackMenuArrow(){
     
        goToMainView()
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
    
    //MARK: - onButtons
    
    
    func onOpenMenu(){
        navigationController?.popViewController(animated: true)
    }
 
    

}
