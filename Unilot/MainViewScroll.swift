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
    
    var profile_tab : ProfileSubView!

    var main_pages = [OnScrollItemCore]()
    
    var current_page = Int(0)
    
    var initWas = false
    
    var scroll_offset = CGFloat(0)
    
    var fon_parallaxed = UIImageView()
    
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

    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        if !initWas   {
            
            fillMainViews()
            
            openCurrentPage()
            
            ifWentFromNotif()
            
            initWas = true
        }

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        
    }
  
     //MARK: -
    
    
    
    func ifWentFromNotif(){
        
        if open_from_notif != nil {
            
            let notif_type = Int(NotifApp.getDataFromNotifString(open_from_notif,2))
            
            refreshView(getTabBarTag(notif_type))
        
        }
        
    }
 

    
    override func setBackButton(){
        
        addMenuButton()
        
    }
    
    override func popViewWasClosed(){
        
        main_pages[current_page].viewDataReload()
        
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
        
        let first_tab =  getFromNib("ViewMain") as! DailyLottery
        first_tab.frame = frame
        first_tab.didLoad(0)
        scrollView.addSubview(first_tab)
        
        
        frame.origin.x += scrollView.frame.width
        let second_tab = getFromNib("ViewMain") as! DailyLottery
        second_tab.frame = frame
        second_tab.didLoad(1)
        scrollView.addSubview(second_tab)

        
        frame.origin.x += scrollView.frame.width
        let third_tab =   getFromNib("BonusView") as! BonusLottery
        
        third_tab.frame = frame
        third_tab.didLoad(2)
        scrollView.addSubview(third_tab)

        
        frame.origin.x += scrollView.frame.width
        profile_tab = getFromNib("ProfileView") as! ProfileSubView
        profile_tab.frame = frame
        profile_tab.didLoad(3)
        scrollView.addSubview(profile_tab)
         

        main_pages = [first_tab,second_tab,third_tab,profile_tab]
        scroll_offset = scrollView.frame.width * 3
        
    }
    
    
    func refreshView(_ newPage: Int){
        
        current_page = newPage
        
        fillSegmentNames()
        
        pop_up_view?.onX(0.2)
        
        openCurrentPage()
    
    }

    func openCurrentPage(){
        
        scrollToCurrentPage()

        sendEvent(kEVENT_main_views[current_page])
        
        main_pages[current_page].viewDataReload()
    }
    
    
    //MARK: - NOTIFICATION

    override func onActiveAppNotifRecieved(_ notif : NotifStruct){
        
        // if updated current game
        playStandart()
        
        let type_ind = getTabBarTag(notif.game.type)
        
        
        if type_ind == current_page {
            
            main_pages[current_page].fillLocalGameData()
        
            main_pages[current_page].viewDataReload()
            
        } else {
            
            // if updates neighbor game
             
            if notif.action != kActionUpdate {
                
                refreshView(type_ind)
                
            } else {
                
                NotifApp.showLocalNotifInApp(withController: navigationController!, notif)
                
            }
            
        }
        
    }
    
    
    
    //MARK: - APP CLOSED OPENED
    
    override func onUserOpenView(){
        
        super.onUserOpenView()

        for view_item in main_pages {
            view_item.onUserOpenView()
        }
        
    }
    
    override func onUserCloseView(){
        
        super.onUserCloseView()
        
        for view in main_pages {
            view.onUserCloseView()
        }
        
    }
    
    
    //MARK: -  Pan gesture
    
    func getFromNib(_ name : String) -> OnScrollItemCore {
       
        let nib_body = UINib(nibName: name, bundle: nil)
        
        return nib_body.instantiate(withOwner: nil, options: nil)[0] as! OnScrollItemCore
     }

    //MARK: -  set
    
    override func setFon(){
        
        fon_parallaxed  = create_fon_view(self.view.frame.size)
        self.view.insertSubview(fon_parallaxed, at: 0)
        
    }

    func fillSegmentNames(){
        
        let customTabBar = view.viewWithTag(666666)!

        for i in 1..<5 {
            
            let uibutton = customTabBar.viewWithTag(i*1000000) as! UIButton
            uibutton.addTarget(self, action: #selector(MainViewScroll.changePage(_:)), for: .touchUpInside)
            
            let imageView = customTabBar.viewWithTag(i*1000000+1) as! SpecialItem
            imageView.tintColor = kColorLightGray

            let label = customTabBar.viewWithTag(i*1000000+2) as! UILabel
            label.text   =  TR(tabbar_strings[i-1]).capitalized
            label.textColor = kColorLightOrange

            
            var image_name = lottery_images[i-1]
            
            if current_page != (i-1) {
                image_name = image_name + "-template"
                label.textColor =  kColorLightGray
            }
            
            imageView.image = UIImage(named : image_name)
            
        }
        
    }
    
    //MARK:-  scroll changed

    
    func changePage(_ sender: UIButton) -> () {
        
        refreshView(sender.tag/1000000-1)
    }
    
     
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        refreshView( Int(round(scrollView.contentOffset.x / scrollView.frame.size.width)) )
    }

    
    func scrollToCurrentPage(){
        
        let x = CGFloat(current_page) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
         
        switch scrollView.panGestureRecognizer.state {
        case .began:
            // User began dragging
            
            profile_tab.stopAllSchedule()
            
            break
        case .changed:
            // User is currently dragging the scroll view
            
            
            break
            
        case .possible:
            
            
            // The scroll view scrolling but the user is no longer touching the scrollview (table is decelerating)
            break
            
        default:
            break
        }

        let parallax_shift = kFakeParallaxShift - scrollView.contentOffset.x * kFakeParallaxShift / scroll_offset
        
        fon_parallaxed.frame.origin = CGPoint(x: -parallax_shift, y: 0)
    }
    
}
