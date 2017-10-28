//
//  MainViewPositions.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit

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

    
    var widthProgress = CGFloat(-1)
        
    //MARK: - Views Load override

//    viewWillLayoutSubviews
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        currentTabBarLottery = tabBarItem.tag
        
        view.backgroundColor = UIColor.clear

        itemBadge?.setNumberLabel(notifications_data["badge"]!)

        setButtonView()

        setGameNumbers()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.opacity = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setGameNumbers()
        
        if widthProgress == -1 {
        
            fillWithData()

            setLoadingSign(toWidth: 0)

            answerOnInitData()

            startSchedule()

        }
        
        animateAppearance()

        
    }
    
 
    
    func  setGameNumbers() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if widthProgress > -1 {
            
            reCountTimers()
            startSchedule()
    
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        MemoryControll.saveObject(moneyTablet.totalCounts,
                                  key: "gameTimeLeft" + local_current_game.game_id)
        
        local_current_game.prize_amount_local = moneyTablet.totalCounts

        stopSchedule()
        
//        animateDisAppearance()
        
    }
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

    func openEndWithFail(){
        
        let viewWithPlaces = LotteryResults.createLotteryResults()
        viewWithPlaces.delegate = self
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        
    }
    
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
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        
    }
    
    @IBAction func showYouWin(){
        
        let viewWithPlaces = YouWin.createYouWin()
        viewWithPlaces.delegate = self
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 0)
        
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
        
        let viewWithPlaces = AgreeToPlay.createAgreeToPlay()
        viewWithPlaces.delegate = self
        let frameForView = CGRect(x: 10,
                                  y: 70,
                                  width: view.frame.width - 20,
                                  height: view.frame.height - 150)
        
        viewWithPlaces.initView(mainView: self.view, frameView: frameForView, directionSign: 1)
        

    }
    
    
    func createOverLayWithWait(){
        
        firstOverlay.isHidden = true
        secondOverlay = UIImageView(frame: firstOverlay.frame)
        view.addSubview(secondOverlay)
        
        secondOverlay.clipsToBounds = true
        secondOverlay.layer.cornerRadius = firstOverlay.layer.cornerRadius
        secondOverlay.backgroundColor = firstOverlay.backgroundColor
        secondOverlay.layer.backgroundColor = firstOverlay.layer.backgroundColor
        
        
        
        let title = UILabel(frame: CGRect(x: 5, y: 5, width: secondOverlay.frame.width - 10, height: 90))
        title.text =  TR("Система \nвыбирает победителя")
        title.textColor = UIColor.white
        title.numberOfLines = 3
        title.font = UIFont(name: kFont_Regular, size: 30)
        title.textAlignment = .center
        secondOverlay.addSubview(title)
        
        
        let timerThin =  CDHourL(frame: CGRect(x: 15, y: 15 + title.frame.height,
                                               width: secondOverlay.frame.width - 30, height: 90))
        timerThin.createBodyTimers()
        timerThin.initTimer(0, 60)
        timerThin.doScheduledTimer()
        secondOverlay.addSubview(timerThin)
        
        
        let tranzaction_string = UILabel(frame: CGRect(x: 5, y: 220,
                                                       width: secondOverlay.frame.width - 10, height: 28))
        
        tranzaction_string.text = local_current_game.game_id
        tranzaction_string.textColor = UIColor.white
        tranzaction_string.numberOfLines = 1
        tranzaction_string.font = UIFont(name: kFont_Regular, size: 14)
        tranzaction_string.textAlignment = .center
        secondOverlay.addSubview(tranzaction_string)
    
    
        let copyButton = UIButton(frame : CGRect(x: 5, y: secondOverlay.frame.height - 60,
                                                width:  secondOverlay.frame.width - 10, height: 60))
        copyButton.setImage(UIImage(named: "copy-x3"), for: .normal)
        copyButton.setTitle(TR("Скопировать номер транзакции"), for: .normal)
        copyButton.titleLabel?.font = UIFont(name: kFont_Regular, size: 14)
        copyButton.layer.backgroundColor = UIColor.clear.cgColor
        copyButton.layer.cornerRadius = 6
        
        secondOverlay.addSubview(copyButton)
    
    }
    
    
    
}


