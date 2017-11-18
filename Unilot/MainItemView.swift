//
//  MainItem.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class MainItemView: LotteryItemsView {
    
        //MARK: - Views Load override
        
    
    override func loadMainSubViews() {
        
        //create bodies and fill the text
        fillWithData()
        
        //fix button layer view
        setButtonView()
         
        // get data from
        fillLocalGameData()
 
        // fill with data
        viewDataReload()
        
    } 
    
    //MARK: -
    
    override func onPrizePlaces() {
        
        local_current_game = current_game
        
        if imageTrophy.isHidden {
            
            sendServerCheckForUpdateData()
            
        } else {
            
            super.onPrizePlaces()
        }
    }
    
    override func onEthButton(){
        
        playStandart()
        
        sendServerCheckForUpdateData()
     
        sendEvent("EVENT_HIDEN_REFRESH")
    }
    
   
    
    override func viewDataReload(){
        
        stopAllSchedule()
        
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
            
            openCompletedViewsForWinnnerOrLoser()
            
            break
            
        default:
            
            
            break
        }
        
        
        openNotifViewsForWinnnerOrLoser()
        
        
        current_controller_core?.setBadgeNumber()
        
        
    }
    
    
    //MARK: -
    
    override func fillLocalGameData(){
        
        current_game = games_list[current_game.type] ?? current_game
        
        local_current_game = current_game
        
    }
    
    
    func setLowerButton(goToPrizeOrRefresh : Bool){
        
        let image_name = goToPrizeOrRefresh ? "prize_places" : "tap_to_refreshed"
        
        prizePlaces.setTitle(TR(image_name), for: .normal)
        
        imageTrophy.isHidden    = !goToPrizeOrRefresh
        imageArrow.isHidden     = !goToPrizeOrRefresh
        
    }
    
    
    func fillWithNoGame(){
        
        titlePrize.text = TR("will_start_soon")
        
        peopleCount.text = "0"
        
        usSum.text = "$ 0"
        
        moneyTablet.initTimer(0,0)
        
        setLowerButton(goToPrizeOrRefresh : false)
    }
    
    func fillWithCurrentGame(){
        
        titlePrize.text = TR("jackpot").capitalized
        
        setLowerButton(goToPrizeOrRefresh : true)
        
        
    }
    
    
    func fillWithGameNumbers(){
        
        
        peopleCount.text = Int(current_game.num_players).stringWithSepator
        
        takePartEth.text = "\(current_game.bet_amount) Eth"
        
        usSum.text = "$ \(current_game.prize_amount_fiat)"
        
        let start_count = MemoryControll.getGameMoneyStart(current_game.game_id)
        
        moneyTablet.initTimer(start_count, Int(current_game.prize_amount * 1000))
        
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
        
        current_controller_core?.showActivityViewIndicator()
        
        NetWork.getGamesList(completion: onAnswerFromServerRefreshed)
        
    }
    
    
    func sendWinnerListRequest(_ game_id : String){
        
        current_controller_core?.showActivityViewIndicator()
        
        NetWork.getListWinners(game_id, completion: onAnswerAfterWinnerList)
        
    }
    
    
    
    func getNotifDataFromNet(_ game_id : String){
        
        current_controller_core?.showActivityViewIndicator()
        
        NetWork.getGameDetails(game_id, completion: onAnswerGameDataFromNet)
    }
    
    
    //MARK: - Notification stuff
    
    func openCompletedViewsForWinnnerOrLoser(){
        
        // show popups for current completed game
        if current_game.status == kStatusComplete{
            
            NotifApp.removeNotifWithSameGameId(current_game.game_id)
            
            current_game.status = kStatusNoGame
            
            sendWinnerListRequest(current_game.game_id)
            
        }
        
    }
    
    func openNotifViewsForWinnnerOrLoser(){
        
        // check current notification item
        
        if let game_id = NotifApp.getIdOfGameIfWeHaveAny() {
            
            if ( NotifApp.getDataFromNotifString(open_from_notif,0) == kActionCompleted) {
                
                open_from_notif = nil

                getNotifDataFromNet(game_id)
             
            }
            
        }
        
        
    }
    
    
    //MARK: - Answers from outside
    
    func onAnswerFromServerRefreshed(_ message : String?){
        
       current_controller_core?.hideActivityViewIndicator()
        
        if message != nil {
            
            current_controller_core?.showError(message!)
            
            
        } else {
            
            
            if games_list[current_game.type] == nil {
                
                current_game.status = kStatusNoGame
                
                viewDataReload()
                
            } else
                
                if current_game.isEqual(to: games_list[current_game.type]!) {
                    
                    setLowerButton(goToPrizeOrRefresh : false)
                    
                } else {
                    
                    fillLocalGameData()
                    
                    viewDataReload()
            }
            
            
        }
        
    }
    
    func onAnswerGameDataFromNet(_ error : String?){
        
        if error != nil {
            
            current_controller_core?.hideActivityViewIndicator()
            
            current_controller_core?.showError(error!)
            
        } else {
            
            sendWinnerListRequest(local_current_game.game_id)
        }
    }
    
    func onAnswerAfterWinnerList(_ error : String?){
        
        if error != nil{
            
            sendServerCheckForUpdateData()
            
            return
        }
        
        current_controller_core?.hideActivityViewIndicator()
        
        
        if (winners_list.count > 0) && (winners_list.first!.user_id != kNullUserId) {
            
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
        
        
    }
    

    
    //MARK: - DELEGATES
    
    override func countDownFinished(){
        
        viewDataReload()
        
    }
    

    
    
    
}


