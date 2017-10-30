//
//  MainViewPositions.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import SCLAlertView

class MainViewPositions: ControllerCore, CountDownTimeDelegate {
    
    @IBOutlet weak var loadingSignFirst: UIImageView!
    @IBOutlet weak var loadingSignProgress: UIImageView!
    
    
    @IBOutlet weak var titleMain: UILabel!
    @IBOutlet weak var titleUntilTheEnd: UILabel!
    @IBOutlet weak var titlePrize: UILabel!
    @IBOutlet weak var takePartEth: UILabel!

    
    @IBOutlet weak var takePart: UIButton!
    @IBOutlet weak var takePartFon: UIImageView!
    
    
    @IBOutlet weak var prizePlaces: UIButton!
    
    @IBOutlet weak var usSum: UILabel!
    @IBOutlet weak var peopleCount: UILabel!
    
    @IBOutlet weak var moneyTablet: CountUppMoney!
    
    @IBOutlet weak var clockTablet: CountDownFullTimer?

    @IBOutlet weak var firstOverlay: UIView!
    
    var secondOverlay: UIImageView!

    var secondTimerThin: CDHourL!
    
    var widthProgress = CGFloat(-1)
    
    var game_type = Int(0)
        
    //MARK: - Views Load override

//    viewWillLayoutSubviews
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.layer.opacity = 0.0
        view.backgroundColor = UIColor.clear
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
         
        itemBadge?.setNumberLabel(notification_data.count)

        setButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setGameNumbers()

        if widthProgress > -1 {
            
            reCountTimers()
            startSchedule()
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        if widthProgress == -1 {
        
            fillWithData()

            setLoadingSign(toWidth: 0)

            answerOnInitData()

            startSchedule()

        }
        
        animateAppearance()
        
    }
  
  
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        MemoryControll.saveObject(moneyTablet.totalCounts,
                                  key: "gameTimeLeft" + local_current_game.game_id)
        
        games_list[tabBarItem.tag]?.prize_amount_local = moneyTablet.totalCounts

        stopSchedule()
        
//        animateDisAppearance()
        
    }
    
    //MARK: -
    override func setBackButton(){
        
        addMenuButton()
        
    }
    
    func fillWithData(){
        
    }
    
    
    func answerOnInitData(){
 
        peopleCount.text = Int(local_current_game.num_players).stringWithSepator
        usSum.text = "$ \(local_current_game.prize_amount)"
        
        moneyTablet.initTimer(Int(local_current_game.prize_amount_local),
                              Int(local_current_game.prize_amount_fiat * 1000))
        
        reCountTimers()
        
    }

    func reCountTimers(){
        
        let data = recountTimersData(local_current_game)
        
        if data.0 == -1 {
            showCompleteView()
        } else {
            setTimersNumbers(data.0, data.1, data.2)
        }
        
    }
    
    func setTimersNumbers(_ from : Int, _ all : Int, _ type: Int) {
        
        clockTablet?.initTimer(from,all)
        clockTablet?.changeTextOnStaticLabels(type)

    }
    
    //MARK: - Set all views
    
    
    func  setGameNumbers() {
        
        local_current_game = games_list[game_type]!
        
    }
    func setTakePartView(){
        
        takePart.setTitle(TR("Принять участие"), for: .normal)
        takePartFon.layer.cornerRadius = takePartFon.frame.height/2
        takePartFon.clipsToBounds = true
        
    }
    
//    override func addSwipeForMenuOpen(){
//        
//        if  tabBarController?.revealViewController() != nil {
//            view.addGestureRecognizer(tabBarController!.revealViewController().panGestureRecognizer())
//        }
//    }
    
    
    func setButtonView(){

        prizePlaces.layer.cornerRadius = prizePlaces.frame.height/2
        prizePlaces.backgroundColor = UIColor.clear
        prizePlaces.isHidden = false
        
    }
    
    //MARK: -  LoadingSign

    
    func setLoadingSign(toWidth: CGFloat ){
        
        let rect = loadingSignFirst.frame
        
        let _loadingSignProgress = loadingSignProgress
        
        widthProgress = toWidth
        

        let widthOfFire = rect.size.width - 2  - toWidth
        
        UIView.animate(withDuration: 0.05) {
            _loadingSignProgress?.frame = CGRect(x: rect.origin.x + 1 + toWidth,
                                               y: rect.origin.y + 1,
                                               width: widthOfFire,
                                               height: rect.size.height - 2)
        }
    }

    func changeProgressLine(from: Int, left: Int){
        
        let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
        
        setLoadingSign(toWidth: newWidth )
        
    }

    //MARK: -  CountDownTimeControll
    
    func pauseCountings(){
        
    }

    
    
    //MARK: -  CountDownTimeDelegate
    
    func countDownDidFall(from: Int, left: Int){
        
        let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
        
        setLoadingSign(toWidth: newWidth )
        
    }
    
    
    func countDownFinished(){
        

    }
    
    //MARK: - timers
    
    func addTimersBody(){
        
        
        
    }
    
    func startSchedule(){
        
    }
    
    func stopSchedule(){
        
    }
    
    
    
    func showCompleteView(){
        
    }
    
    
    //MARK: - onButtons

    
    func openEndWithWin(){
        
        let viewWithPlaces = YouWin.createYouWin()
        viewWithPlaces.delegate = self
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 0)
        
    }
    
    @IBAction func onHowDoesItWork(){
       
        let viewWithPlaces = InfoView.createInfoView()
        viewWithPlaces.delegate = self
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 140)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        
    }
    
    
    func showYouWin(_ user : UserForGame){
        
        let viewWithPlaces = YouWin.createYouWin()
        viewWithPlaces.delegate = self
        viewWithPlaces.user_data = user
        
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 0)
        
    }
    
    func openEndWithFail(){
        
        let viewWithPlaces = LotteryResults.createLotteryResults()
        viewWithPlaces.delegate = self
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        
    }
    
    
    @IBAction func onPrizePlaces(){
        
        let viewWithPlaces = TotalPrizeFond.createTotalPrizeFond()
        viewWithPlaces.delegate = self
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        
    }
    
    
    @IBAction func onTakePart(){
        
        openSecondView()
        
//        let viewWithPlaces = AgreeToPlay.createAgreeToPlay()
//        viewWithPlaces.delegate = self
//        let frameForView = CGRect(x: 10,
//                                  y: 70,
//                                  width: view.frame.width - 20,
//                                  height: view.frame.height - 150)
//        
//        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
//        
//
    }
    
    
    func openSecondView(){
        
        // create second layer
        createOverLayWithWait()

        secondTimerThin.doScheduledTimer()

        UIView.animate(withDuration: 1, animations: {
            
            self.firstOverlay.layer.opacity = 0.0

        })
        
        UIView.animate(withDuration: 2, animations: {

            self.secondOverlay.layer.opacity = 1.0
            
        })
        
    }
    
    func onReloadDataForMainView(){
        
        showActivityViewIndicator()

        UIView.animate(withDuration: 1, animations: {
            
            self.firstOverlay.layer.opacity = 0.0
            self.secondOverlay.layer.opacity = 0.0
            
        }){ (_ animate : Bool) in
            
            self.secondOverlay.removeFromSuperview()
            
        }
        
        NetWork.getListWinners(completion: onAnswerAfterWinnerList)
    }
    
    //MARK: - Hide and Show SecondTimer
    
    func showViewsAfterWinnerList(){
        
        my_win_wallets = winners_list.filter({ (item : UserForGame) -> Bool in
            
            return users_account_number.contains(item.user_id)
        })
        
        showYouWin(local_current_user)

        
//        if my_win_wallets.count > 0 {
//            
//            for item in my_win_wallets {
//                showYouWin(item)
//            }
//            
//        } else {
//            
//            openEndWithFail()
//            
//        }
        
        NetWork.getGamesList(completion: onAnswerAfterNewDataRequest)


    }

    
    func createOverLayWithWait(){
   
        secondOverlay = UIImageView(frame: firstOverlay.frame)
        secondOverlay.clipsToBounds = true
        secondOverlay.layer.cornerRadius = firstOverlay.layer.cornerRadius
        secondOverlay.backgroundColor = UIColor.uuDarkTwo.withAlphaComponent(0.8)
        
        
        let title = UILabel(frame: CGRect(x: 5, y: 0,
                                          width: secondOverlay.frame.width - 10,
                                          height: secondOverlay.frame.height * 0.35))
        title.text =  TR("Система\nвыбирает победителя")
        title.textColor = UIColor.white
        title.numberOfLines = 2
        title.font = UIFont(name: kFont_Medium, size: 17)
        title.textAlignment = .center
        secondOverlay.addSubview(title)
        
        secondTimerThin = CDHourL(frame: CGRect( x: secondOverlay.frame.width * 0.33,
                                                 y: title.frame.height,
                                             width: secondOverlay.frame.width * 0.34,
                                            height: secondOverlay.frame.height * 0.15))
        secondTimerThin.createBodyTimers()
        secondTimerThin.initTimer(3600, 0)
        secondOverlay.addSubview(secondTimerThin)
        
        let tranzaction_string = UILabel(frame: CGRect(x: 15,
                                                       y: secondTimerThin.frame.origin.y + secondTimerThin.frame.height + 5,
                                                       width: secondOverlay.frame.width - 30,
                                                       height: 20))
        
        tranzaction_string.text = local_current_game.smart_contract_id
        tranzaction_string.textColor = UIColor.white
        tranzaction_string.numberOfLines = 1
        tranzaction_string.font = UIFont(name: kFont_Regular, size: 14)
        tranzaction_string.adjustsFontSizeToFitWidth = true
        tranzaction_string.textAlignment = .center
        secondOverlay.addSubview(tranzaction_string)
    
    
        let copyButton = UIButton(frame : CGRect(x: 15,
                                                 y: tranzaction_string.frame.origin.y + tranzaction_string.frame.height + 10,
                                                width:  secondOverlay.frame.width - 30,
                                                height: secondOverlay.frame.height * 0.2))
        
        copyButton.setImage(UIImage(named: "copy-x3"), for: .normal)
        copyButton.setTitle("  " + TR("Скопировать номер транзакции"), for: .normal)
        copyButton.titleLabel?.font = UIFont(name: kFont_Regular, size: 14)
        copyButton.backgroundColor = UIColor.clear
        copyButton.layer.borderColor = UIColor.white.cgColor
        copyButton.layer.borderWidth = 0.5
        copyButton.layer.cornerRadius = 6
        copyButton.tintColor = kColorLightOrange
        copyButton.titleLabel?.textColor = UIColor.white
        copyButton.addTarget(self, action: #selector(MainViewPositions.onCopyTransactionNumber), for: .touchUpInside)
        secondOverlay.addSubview(copyButton)
        
        secondOverlay.isUserInteractionEnabled = true
        secondOverlay.layer.opacity = 0.0
        view.addSubview(secondOverlay)
    }
    
    
    
    func reloadViewForFirstLayer(){
        
        setGameNumbers()
        
        answerOnInitData()
        
        UIView.animate(withDuration: 0.5) {
            self.firstOverlay.layer.opacity = 1.0
        }
    }
    
    
    func onCopyTransactionNumber(){
     
        onReloadDataForMainView()
//        saveToClipboard(local_current_game.smart_contract_id)

    }
    
    
    func onAnswerAfterWinnerList(_ error : String?){
        
        hideActivityViewIndicator()
        
        if error != nil{
            
            SCLAlertView().showError(" ", subTitle: error!)
            
        } else {
            
            showViewsAfterWinnerList()
        }
        
    }
    
    func onAnswerAfterNewDataRequest(_ error : String?){
        
        if error != nil{
            
            SCLAlertView().showError(" ", subTitle: error!)
            
        } else {
            
            reloadViewForFirstLayer()
        }
        
    }
    
}


