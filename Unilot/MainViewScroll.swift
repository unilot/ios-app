//
//  MainViewScroll.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


//SB_MainViewScroll

import UIKit
import SCLAlertView


class MainViewScroll: ControllerCore , UIScrollViewDelegate {

    @IBOutlet weak var scrollView : UIScrollView!
 
    
    var first_tab   : DailyLottery!
    
    var second_tab  : DailyLottery!
    
    var third_tab   : BonusLottery!
    
    var profile_tab : ProfileSubView!

    var main_pages = [OnScrollItemCore]()
    
    var current_page = Int(0)
    
    var initWas = false
    //MARK: - Views Load override
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setNavControllerClear()
        
        setFon()
        
        setTitle()
        
        setBackButton()
        
        addInfoButton()
        
        fillSegmentNames()
         
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        if !initWas   {
            
            fillMainViews()
            
            ifNeedTutorial()
            
            ifWentFromNotif()
            
            initWas = true
        }

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        
    }
    
    
    func ifWentFromNotif(){
        
        if open_from_notif != nil {
            
            let notif_type = Int(NotifApp.getDataFromNotifString(open_from_notif,2))
            
            goToPage(getTabBarTag(notif_type))
        }
        
    }
 
    
    func ifNeedTutorial(){
        if open_from_notif == default_first_launch {
            
            open_from_notif = nil
            
            openTutorialFirst()
        }
        
    }
    
    override func setBackButton(){
        
        addMenuButton()
        
    }
    
    override func popViewWasClosed(){
        
        main_pages[current_page].answerOnInitData()
        
    }
    
    
    override func onQRAnswer(_ haveText : String?){
        
        profile_tab.onQRAnswer(haveText)

    }
    
    
    func fillMainViews(){
        
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = UIColor.clear
        scrollView.layoutIfNeeded()
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(4),
                                        height: scrollView.frame.size.height)
        
        var frame = CGRect(x: 0, y:  0,
                           width: scrollView.frame.width,  height: scrollView.frame.height)
        
        first_tab =  UINib(nibName: "ViewMain", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailyLottery
        first_tab.frame = frame
        first_tab.didLoad(0)
        scrollView.addSubview(first_tab)
        
        
        frame.origin.x += scrollView.frame.width
        second_tab =  UINib(nibName: "ViewMain", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailyLottery
        
        second_tab.frame = frame
        second_tab.didLoad(1)
        scrollView.addSubview(second_tab)

        
        frame.origin.x += scrollView.frame.width
        third_tab =  UINib(nibName: "BonusView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BonusLottery
        
        third_tab.frame = frame
        third_tab.didLoad(2)
        scrollView.addSubview(third_tab)

        
        frame.origin.x += scrollView.frame.width
        profile_tab =  UINib(nibName: "ProfileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfileSubView
        
        profile_tab.frame = frame
        profile_tab.didLoad(3)
        scrollView.addSubview(profile_tab)
         

        main_pages = [first_tab,second_tab,third_tab,profile_tab]
        
    }
    
    //MARK: - NOTIFICATION
    
    
    
    func updateAppearanceOfGames(){
        
        for view_item in main_pages {
            view_item.fillLocalGameData()
            view_item.answerOnInitData()
            
        }
        
    }
    
    
    func updateGameforNotification(){
        
        for view_item in main_pages {
            view_item.fillLocalGameData()
        }
        
    }
    
    
    // if app was sleeping
    override func onCheckAppNotifRecieved() {
        
        updateGameforNotification()
        
    }
    
    // if app was active
    override func onActiveAppNotifRecieved(_ notif : NotifStruct){
        
        // if updated current game
        playStandart()
        
//        if notif.game.type == current_page {
//            
//            fillLocalGameData()
//            
//            answerOnInitData()
//            
//        } else {
//            
//            // if updates neighbor game
//            
//            
//            if notif.action != kActionUpdate {
//                
//                tabBarController?.selectedIndex = getTabBarTag(notif.game.type)
//                
//            } else {
//                
//                NotifApp.showLocalNotifInApp(withController: navigationController!, notif)
//                
//            }
//            
//        }
//        
    }
    
    
    
    //MARK: - APP CLOSED OPENED
    
    override func onUserOpenView(){
        
        for view_item in main_pages {
            view_item.onUserOpenView()
        }
        
    }
    
    override func onUserCloseView(){
        
        for view in main_pages {
            view.onUserCloseView()
        }
        
    }
    
    
    //MARK:-  segment
    
    
    func fillSegmentNames(){
        
        for i in 1..<5 {
            
            let uibutton = view.viewWithTag(i*1000000) as! UIButton
            uibutton.addTarget(self, action: #selector(MainViewScroll.changePage(_:)), for: .touchUpInside)
            
            var imageView = view.viewWithTag(i*1000000+1) as! SpecialItem
            
            let image = lottery_images[i-1] + "-template"
            let label = view.viewWithTag(i*1000000+2) as! UILabel
            label.text   =  TR(tabbar_strings[i-1]).capitalized
            
            
            if current_page == (i-1) {
                
//                imageView = setColorForImage(imageView.frame.size, image)

                imageView.image = UIImage(named : image)
                imageView.tintColor = kColorLightOrange

                label.textColor = kColorLightOrange
                

            } else {
                imageView.image = UIImage(named : image)
                imageView.tintColor = kColorLightGray

                label.textColor =  kColorLightGray
 
            }
        }
        
    }
    
    //MARK:-  scroll changed
    
    func goToPage(_ newPage: Int){
        
        current_page = newPage
        
        fillSegmentNames()

        let x = CGFloat(current_page) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        
    }

    func changePage(_ sender: UIButton) -> () {
        
        goToPage(sender.tag/1000000-1)
    }
    
     
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        current_page = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        
        goToPage(current_page)
    }
    

}
