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
        
//        sendServerCheckForUpdateData()
        
        // fake data
        
        NotifApp.sendFakeLocalPush()

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

        let image_name = goToPrizeOrRefresh ? "Призовые места" : "Обновить данные"
        
        prizePlaces.setTitle(TR(image_name), for: .normal)
        
        imageTrophy.isHidden    = !goToPrizeOrRefresh
        imageArrow.isHidden     = !goToPrizeOrRefresh
        
    }
    
    
    func fillWithNoGame(){
        
        titlePrize.text = TR("Скоро начнется ....")

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
        if let game_id = NotifApp.getIdOfGameIfCompletedInMemory() {
            
            showActivityViewIndicator()
            
            // will deal only with completed results
            NetWork.getListWinners(game_id, completion: onAnswerAfterWinnerList)
            
        }
         
        // clean the flag
        open_from_notif = nil
        
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
             
            sendServerCheckForUpdateData()
            
            return
        }
        
        hideActivityViewIndicator()

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
    
    
    override func onCheckAppNotifRecieved(){
        
        let type_ofNotif = Int(NotifApp.getDataFromNotifString(open_from_notif,2))
        
        let typeId = getTabBarTag(type_ofNotif)
        
        // if updeted current game
        
        if type_ofNotif == current_game.type {
            
            answerOnInitData()
            
        } else {
            
            // if updates neighbor game
            tabBarController?.selectedIndex = typeId
        }
    }
    
    
    override func onActiveAppNotifRecieved(_ notif : NotifStruct){

        // if updeted current game
        

        if notif.game.type == current_game.type {
             
            // save current flipper meanings of money for next smooth animation
            MemoryControll.saveGameMoneyStart ( Int(current_game.prize_amount_fiat) / 1000, notif.game)

            fillLocalGameData()
            
            answerOnInitData()
            
        } else {
            
            // if updates neighbor game
            
            if notif.action != kActionUpdate {
                
                tabBarController?.selectedIndex = getTabBarTag(notif.game.type)
            }
            
        }
         
    }
    

    func notifStuff(){
        
    }
    
    
    override func countDownFinished(){
        
        answerOnInitData()
        
    }
    
    
    override func popViewWasClosed(){
        
        answerOnInitData()

    }
    
    

}


