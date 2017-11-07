//
//  MainViewPositions.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import SCLAlertView

class MainViewPositions: TabBarTimersViewCore {
    
    
    //MARK: - Views Load override
     
    override func viewDidLoad() {
        
        current_game.type = kTypeTabBarOrder[tabBarItem.tag]
        
        super.viewDidLoad()
        
        view.layer.opacity = 0.0
        view.backgroundColor = UIColor.clear
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        // get data from
        fillLocalGameData()

        onCreateEverything()
        
        // fill with data
        answerOnInitData()
        
        // open view for user
        animateAppearance()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if current_game.status != kStatusNoGame {
            
            local_current_game = current_game
            
            onUserCloseView()
            
        }
        
    }
    
    override func onUserOpenView(){
        
        answerOnInitData()
        
    }
    
    override func onUserCloseView(){
        
        stopAllSchedule()
        
    }
    
    
    
    //MARK: -
    
    override func onPrizePlaces() {
        
        if imageTrophy.isHidden {
            
            sendServerCheckForUpdateData()
            
        } else {
            
            super.onPrizePlaces()
        }
    }
    
    
    
    override func onEthButton(){

        playStandart()
        
        sendServerCheckForUpdateData()
        
        // fake data
        
//        NotifApp.sendFakeNotif()
        
        
    }
    
    func onCreateEverything(){
        
        // if first time opened the view
        if widthProgress == -1 {
            
            // names of titleMain
            setLotteryName()
            
            //create bodies and fill the text
            fillWithData()
            
            
            //fix button layer view
            setButtonView()
            
            // create progress bar
            setLoadingSign(toWidth: 0)
            
        }
        
    }

    
    
    func answerOnInitData(){
        
        itemBadge?.setNumberLabel(notification_data.count)
        
        stopAllSchedule()
        
        openViewsForWinnnerOrLoser()

        switch current_game.status {
            
        //  game in progress      // game is caclulating the winner
        case kStatusPublished,          kStatusFinishing:
            
            fillWithCurrentGame()
            
            fillWithGameNumbers()
            
            if current_game.status == kStatusPublished {
                
                openFirstLayer()
                
            }
            
            if current_game.status == kStatusFinishing {
                
                openSecondView()
                
            }
            
            break
            
            
            
        // game was canceled by some reason // no game started yet  // game was finished
        case kStatusUndefined, kStatusCancele, kStatusNoGame ,  kStatusComplete:
            
            animateFirstViewAppearance(0.0, 0.05)
            
            animateSecondViewAppearance(0.0)
            
            fillWithNoGame()
            
            
            break
            
        default:
            
            
            break
        }
        
        
        
        
    }
    
    
    //MARK: -
    
    
    func fillLocalGameData(){
        
        current_game = games_list[current_game.type] ?? current_game
        
        local_current_game = current_game
        
    }

    
    func setLowerButton(goToPrizeOrRefresh : Bool){

        let image_name = goToPrizeOrRefresh ? "Призовые места" : "Tap To refresh"
        
        prizePlaces.setTitle(TR(image_name), for: .normal)
        
        imageTrophy.isHidden    = !goToPrizeOrRefresh
        imageArrow.isHidden     = !goToPrizeOrRefresh
        
    }
    
    
    func fillWithNoGame(){
        
        titlePrize.text = TR("Will be soon ....")

        peopleCount.text = "0"
        
        usSum.text = "$ 0"

        setLowerButton(goToPrizeOrRefresh : false)
    }
    
    func fillWithCurrentGame(){
        
        titlePrize.text = TR("Джекпот")
        
        setLowerButton(goToPrizeOrRefresh : true)


    }

    
    func fillWithGameNumbers(){
        

        peopleCount.text = Int(current_game.num_players).stringWithSepator

        takePartEth.text = "\(current_game.bet_amount) Eth"

        usSum.text = "$ \(current_game.prize_amount_fiat)"
        
        moneyTablet.initTimer(Int(current_game.prize_amount_local),
                              Int(current_game.prize_amount * 1000))
        
   

    }
    //MARK: - OPEN VIEWS

    
    func openFirstLayer(){
        
        // hide other view
        animateSecondViewAppearance(0.0)
        
        let data = recountTimersData(current_game)
        
        if data.2 > -1 {
            
            setTimersNumbers(data.0, data.1, data.2)
            
            // start timers
            startTimersOnFirstView()
            
            // reveal view
            animateFirstViewAppearance(1.0, 0.05)
  
        } else {
            
            sendServerCheckForUpdateData()
        }
        
    }
    
    
    func openSecondView(){

        // fill money field with flipping number
        moneyTablet.completeFlipping()

        // hide other view
        animateFirstViewAppearance(0.0)
         
        setSecondOverlay()
        
        let data = recountTimersForLastCounter(current_game)
        
        if data.1 > -1 {

            secondTimerThin?.initTimer(data.0,data.1)
            
            // start timers
            secondTimerThin?.doScheduledTimer()
            
            // reveal view
            animateSecondViewAppearance(1.0)
            
        } else {
            
            sendServerCheckForUpdateData()
        
        }


        
    }
    
    //MARK: - connect server
 
    func sendServerCheckForUpdateData(){
        
        showActivityViewIndicator()
        
        NetWork.getGamesList(completion: onAnswerFromServerRefreshed)
        
    }
    
    
    //MARK: - Notification stuff
    
    func openViewsForWinnnerOrLoser(){
        
        // check current notification item
        let game_id = checkNotificationFromLaunch()
        
        // clean the flag
        open_from_notif = nil
 
        
        if game_id != nil {
            
            // will deal only with completed results
            NetWork.getListWinners(game_id!, completion: onAnswerAfterWinnerList)
            
        }
        
        
    }
    
    func checkNotificationFromLaunch() -> String? {
        
        let game_id = NotifApp.getDataFromNotifString(1)
        
        if (open_from_notif != nil) {
            
            // search for item in notification memory
            if let notif = NotifApp.getElementFromNotif(open_from_notif!) {
                
                // remove found item from memory
                NotifApp.saveNewNotifWithoutElement(notif)

                // return the id of game
                return  game_id
            }            
        }
        
        return nil
    }
    
    //MARK: - Answers from outside
    
    
    func onAnswerFromServerRefreshed(_ message : String?){
        
        
        hideActivityViewIndicator()
        
        if message != nil {
            
            showError(message!)
            
            
        } else {
            
            
            if games_list[current_game.type] == nil {
                
                current_game.status = kStatusNoGame
                
                answerOnInitData()

            } else
            if current_game.isEqual(to: games_list[current_game.type]!) {
                
                setLowerButton(goToPrizeOrRefresh : false)
                
            } else {
                
                fillLocalGameData()
                
                answerOnInitData()
            }
            
            
        }
        
    }
    
    
    func onAnswerAfterWinnerList(_ error : String?){
        
        if error != nil{
         
            return
        }
        
        let my_win_wallets = winners_list.filter({ (item : UserForGame) -> Bool in
            
            return users_account_number.contains(item.user_id)
        })
        
        if my_win_wallets.count > 0 {
            
            for item in my_win_wallets {
                showYouWin(item)
            }
            
        } else {
            
            showYouLost()
        }
    }
    
    
    override func onNotifRecieved(_ notif : NotifStruct){

        playStandart()

        // if updeted current game
        

        if notif.game.type == current_game.type {
            
            answerOnInitData()
            
        } else {
            
            // if updates neighbor game
            
            if notif.action != kActionUpdate {
                
                tabBarController?.selectedIndex = getTabBarTag(notif.game.type)
            }
            
        }
         
    }
    

    
    
    override func countDownFinished(){
        
        answerOnInitData()
        
    }
    
    
    

}


