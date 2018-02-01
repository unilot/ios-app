//
//  OnScrollItemCore.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
 
class  LotteryItemsView : OnScrollItemCore,
    CountDownTimeDelegate,
    CountUppFlippersMoneyDelegate{
    
    
    //MARK: - Vars
    
    @IBOutlet weak var loadingSignFirst: UIImageView!
    @IBOutlet weak var loadingSignProgress: UIImageView!
    
    
    @IBOutlet weak var titleUntilTheEnd: UILabel!
    @IBOutlet weak var titlePrize: UILabel!
    @IBOutlet weak var takePartEth: UILabel!
    
    
    @IBOutlet weak var takePart: UIButton!
    @IBOutlet weak var takePartFon: UIImageView!
    
    @IBOutlet weak var imageTrophy: UIImageView!
    @IBOutlet weak var imageArrow : UIImageView!
    
    @IBOutlet weak var ethFakeButton: UIButton!
    
    
    @IBOutlet weak var prizePlaces: UIButton!
    
    @IBOutlet weak var usSum: UILabel!
    @IBOutlet weak var peopleCount: UILabel!
    
    @IBOutlet weak var moneyTablet: CountUppMoney!
    
    @IBOutlet weak var clockTablet: CountDownFullTimer?
    
    @IBOutlet weak var firstOverlay: UIView!
    
    var secondOverlay: UIImageView?
    
    var secondTimerThin: CDHourL?
    
    var widthProgress = CGFloat(-1)
    
    var current_game = GameInfo()
    
    //MARK: -
    
    //MARK: - FUNCTIONS
    
    override func setMainTitle (_ indexNum : Int){
        
        current_game.type = kTypeTabBarOrder[indexNum]

        titleMain.text = TR(tabbar_strings[indexNum]).capitalized + " " + TR("drawing1")
        
    }
    
    func setTimersNumbers(_ from : Int, _ all : Int, _ type: Int) {
        
        clockTablet?.initTimer(from,all)
      
        clockTablet?.changeTextOnStaticLabels(type)
        
        initLoadingLine(from: all, left: from)
        
     }
    
    
    //MARK: - Set all views
    
    
    func setTakePartView(){
        
        takePartFon.layer.cornerRadius = takePartFon.frame.height/2
        takePartFon.clipsToBounds = true
        
    }
    
    
    func setButtonView(){
        
        prizePlaces.layer.cornerRadius = prizePlaces.frame.height/2
        prizePlaces.backgroundColor = UIColor.clear
        prizePlaces.isHidden = false
        
    }
    
    //MARK: -  LoadingSign
  
 
    func setLoadingSign(toWidth: CGFloat, _ progressSpeed : TimeInterval = 0.05 ){
        
        let rect = loadingSignFirst.frame
        
        widthProgress = toWidth
        
        let widthOfFire = rect.size.width - 2  - toWidth
        
        let newRect = CGRect(x: rect.origin.x + 1 + toWidth,
                             y: rect.origin.y + 1,
                             width: widthOfFire,
                             height: rect.size.height - 2)
        

        guard progressSpeed > 0  else {
            loadingSignProgress.frame = newRect

            return
        }
        
        
        UIView.animate(withDuration: progressSpeed) {
            self.loadingSignProgress.frame = newRect
         }
        

    }
    
    
    //MARK: -  CountDownTimeDelegate
    
    func initLoadingLine(from: Int, left: Int){
        
        let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
            
        setLoadingSign(toWidth: newWidth , 0)
        
    
    }
    
    
    func countDownDidFall(from: Int, left: Int){
        
        if current_game.status == kStatusPublished{
            
            let newWidth =  CGFloat(loadingSignFirst.frame.width) * ( 1 - CGFloat(left) / CGFloat(from))
            
            setLoadingSign(toWidth: newWidth )
        }
    }
    
    func countDownFinished(){
        
    }
    
    func countUppMoneyFinished(_ currentTime : Int ){
        
        MemoryControll.saveGameMoneyStart ( currentTime, current_game.game_id)
        
    }
    
    //MARK: - override
    
    func addTimersBody(){
        
        moneyTablet.initConstants(current_game.type, self)
        
        moneyTablet.createBody()
        
        
    }
    
    func startTimersOnFirstView(){
        
    }
    
    func fillWithData(){
        
        
        
    }
     
    func pauseCountings(){
        
    }
    
    
    
    //MARK: - onButtons
    
    
    func onCopyTransactionNumber(){
        
        saveToClipboard(current_game.smart_contract_id)
        
    }
    
    
    
    @IBAction func onHowDoesItWork(){
        
        
        current_controller_core!.onTutorialWithButton()
        
//        let viewWithPlaces = InfoView.createInfoView()
//        viewWithPlaces.delegate = current_controller_core
//        current_controller_core!.pop_up_view = viewWithPlaces
//        viewWithPlaces.initView(mainView: current_controller_core!.view, directionSign: 1)
//
//        sendEvent("EVENT_BONUS_HOWTO")
        
    }
    
    
    @IBAction func onPrizePlaces(){
 
        if pop_up_upper_view != nil {
            return
        }
        
        let viewWithPlaces = TotalPrizeFond.createTotalPrizeFond()
        viewWithPlaces.delegate = current_controller_core
        current_controller_core!.pop_up_view.append(viewWithPlaces)

        viewWithPlaces.initView(mainView: current_controller_core!.view, directionSign: 1)
        
    }
    
    
    @IBAction func onTakePart(){
 
        if pop_up_upper_view != nil {
            return
        }
        
        if current_game.status != kStatusPublished {
            return
        }
        
        local_current_game = current_game
        
        let viewWithPlaces = AgreeToPlay.createAgreeToPlay()
        viewWithPlaces.delegate = current_controller_core
        current_controller_core!.pop_up_view.append(viewWithPlaces)
        viewWithPlaces.initView(mainView: current_controller_core!.view, directionSign: 1)

        sendEvent("EVENT_\(kEVENTS_middle[current_game.type]!)_PARTICIPATE")
    }

    
    
    
    @IBAction func onEthButton(){
        
    }
    
    //MARK: - Hide and Show SecondTimer
    
    
    func showYouLost(){

        let viewWithPlaces = LotteryResults.createLotteryResults()
        viewWithPlaces.delegate = current_controller_core
        
        viewWithPlaces.initView(mainView: current_controller_core!.view, directionSign: 1)
 
    }
    
    
    func showYouWin(_ user : UserForGame){

        let viewWithPlaces = YouWin.createYouWin()
        viewWithPlaces.delegate = current_controller_core
        viewWithPlaces.user_data = user
        
        viewWithPlaces.initView(mainView: current_controller_core!.view, directionSign: 1)
 
    }
    
    
    
    // MARK: - create second view
    
    func updateSecondOverlay(){
        
        if secondOverlay != nil {
            
            if let item = secondOverlay?.viewWithTag(10000) as? UILabel {
                item.text =  TR("system_is_choosing")
            }
            
            if let item = secondOverlay?.viewWithTag(20000) as? UILabel {
                item.text =  current_game.smart_contract_id
            }
            
            if let item = secondOverlay?.viewWithTag(30000) as? UIButton {
                item.setTitle("  " + TR("copy_transaction"), for: .normal)
            }
            
        }
        
    }
    
    func setSecondOverlay(){
        
        if secondOverlay == nil {
            createSecondOverlay()
        }
        
        updateSecondOverlay()
        
    }
    
    func createSecondOverlay(){
        
        
        secondOverlay = UIImageView(frame: firstOverlay.frame)
        secondOverlay!.clipsToBounds = true
        secondOverlay!.layer.cornerRadius = firstOverlay.layer.cornerRadius
        secondOverlay!.backgroundColor = UIColor.uuDarkTwo.withAlphaComponent(0.8)
        
        
        let title = UILabel(frame: CGRect(x: 5, y: 0,
                                          width: secondOverlay!.frame.width - 10,
                                          height: secondOverlay!.frame.height * 0.35))
        title.textColor = UIColor.white
        title.numberOfLines = 2
        title.tag = 10000
        title.font = UIFont(name: kFont_Medium, size: 17)
        title.textAlignment = .center
        secondOverlay!.addSubview(title)
        
        secondTimerThin = CDHourL(frame: CGRect( x: secondOverlay!.frame.width * 0.33,
                                                 y: title.frame.height,
                                                 width: secondOverlay!.frame.width * 0.34,
                                                 height: secondOverlay!.frame.height * 0.15))
        secondOverlay!.addSubview(secondTimerThin!)
        secondTimerThin!.createHourCounter(self)
        
        let tranzaction_string = UILabel(frame: CGRect(x: 15,
                                                       y: secondTimerThin!.frame.origin.y + secondTimerThin!.frame.height + 5,
                                                       width: secondOverlay!.frame.width - 30,
                                                       height: 20))
        
        tranzaction_string.textColor = UIColor.white
        tranzaction_string.numberOfLines = 1
        tranzaction_string.font = UIFont(name: kFont_Regular, size: 14)
        tranzaction_string.adjustsFontSizeToFitWidth = true
        tranzaction_string.textAlignment = .center
        tranzaction_string.tag = 20000
        
        secondOverlay!.addSubview(tranzaction_string)
        
        
        let copyButton = UIButton(frame : CGRect(x: 15,
                                                 y: tranzaction_string.frame.origin.y + tranzaction_string.frame.height + 10,
                                                 width:  secondOverlay!.frame.width - 30,
                                                 height: secondOverlay!.frame.height * 0.2))
        
        copyButton.setImage(UIImage(named: "copy-x3"), for: .normal)
        copyButton.titleLabel?.font = UIFont(name: kFont_Regular, size: 14)
        copyButton.backgroundColor = UIColor.clear
        copyButton.tag = 30000
        copyButton.layer.borderColor = UIColor.white.cgColor
        copyButton.layer.borderWidth = 0.5
        copyButton.layer.cornerRadius = 6
        copyButton.tintColor = kColorLightOrange
        copyButton.titleLabel?.textColor = UIColor.white
        copyButton.addTarget(self, action: #selector(LotteryItemsView.onCopyTransactionNumber), for: .touchUpInside)
        secondOverlay!.addSubview(copyButton)
        
        secondOverlay!.isUserInteractionEnabled = true
        secondOverlay!.layer.opacity = 0.0
        addSubview(secondOverlay!)
    }
    
    
    
    //MARK: - animateView
    
    func animateFirstViewAppearance( _ opacity : Float,_ speed: Double = 1.0) {
        
        UIView.animate(withDuration: speed, animations: {
            
            self.firstOverlay.layer.opacity = opacity
            
        })
    }
    
    func animateSecondViewAppearance( _ opacity : Float, _ speed: Double = 2.0) {
        
        if secondOverlay == nil {
            return
        }
        
        UIView.animate(withDuration: speed, animations: {
            
            self.secondOverlay?.layer.opacity = opacity
            
        }) { (_ animated : Bool) in
            
            if opacity > 0 {
                
            } else {
                self.secondOverlay?.removeFromSuperview()
                self.secondOverlay = nil
                
            }
            
        }
    }
    

}


