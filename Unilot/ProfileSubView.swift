//
//  ProfileSubView.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import AVFoundation 


import UIKit

var exitAsPopUp = 0

class ProfileViewController: ControllerCore {
    
    var profile_tab : ProfileSubView!
    
     override func setTitle() {
 
        navigationItem.title = " "
        
        sendEvent("EVENT_PROFIL")
    }
    
    
    override func onInfoBarButton(){
        
        onShowWalletsAlert()
        
    }

    //MARK: - NOTIFICATION
    
    
    override func onActiveAppNotifRecieved(_ notif : NotifStruct){
        
        playStandart()
        
        if notif.action == kActionCompleted {
            
            goToMainViewFromType(notif.game.type)
            
        } else {
            
            NotifApp.showLocalNotifInApp(withController: self, notif)
            
        }
        
    }
    
    
    //MARK: - Views Load override

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        profile_tab.stopAllSchedule()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.clipsToBounds = true

        view.backgroundColor = kColorMenuDarkFon
            
        setNavControllerClear()
        
        navigationController?.navigationBar.isHidden = true
 
        setTitle()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
 
        addMainView()

        addBackColorButton()
        
        addInfoButton()

    }
    
    func addMainView(){
  
        current_controller_core = self

        profile_tab = getFromNib("ProfileView") as! ProfileSubView
        profile_tab.frame = CGRect(x: 0, y: getStatusbarShift() , width: view.frame.width, height: view.frame.height)
        profile_tab.didLoad(0)
        view.addSubview(profile_tab)
    }
    
   
    
    //MARK: -  FROM NIB
    
    func getFromNib(_ name : String) -> OnScrollItemCore {
        
        let nib_body = UINib(nibName: name, bundle: nil)
        
        return nib_body.instantiate(withOwner: nil, options: nil)[0] as! OnScrollItemCore
    }
    
    
    override func onQRAnswer(_ haveText : String?){
        
        profile_tab.onQRAnswer(haveText)
        
    }
    
    @objc func onGoToGames(){
        
        if exitAsPopUp == 0 {

            current_controller_core?.goToMainView(getTabBarTag())

        } else {
            
            presentingViewController?.dismiss(animated: true, completion: {
                if exitAsPopUp == 2 {
                    if  users_account_wallets.count > 0 {
                         current_controller_core?.onOpenTakePartView()
                    }
                }
            })
        }
    }
    
    //MARK: - fake nav button
    
    
    func addBackColorButton() {
        
        //        setBackButton()
        let point = CGPoint(x: 0 , y : getStatusbarShift() + 4)
        let size = CGSize(width: 30, height: 30)
        
        let backButtonFace = setColorForImage(size, "arrow_back")
        backButtonFace.frame.origin = point

        let button = UIButton(frame: CGRect(origin: point, size: size))
        button.addTarget(self, action: #selector(ProfileSubView.onGoToGames) , for: .touchUpInside)
 
        profile_tab.addSubview(backButtonFace)
        profile_tab.addSubview(button)
    }
    
    
    func  addInfoButton(){
        
        let point = CGPoint(x: profile_tab.frame.width - 40 , y : getStatusbarShift() + 4 )
        let size = CGSize(width: 30, height: 30)
        
        let button = UIButton(frame: CGRect(origin: point, size: size))
        button.setImage(UIImage(named:"info2-x3"), for: .normal)
        button.addTarget(self, action: #selector(ControllerCore.onInfoBarButton) , for: .touchUpInside)
      
        profile_tab.addSubview(button)

    }
    
    

    
    
}

class ProfileSubView: OnScrollItemCore, UITextFieldDelegate,  UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var attentionText: UILabel!

    @IBOutlet weak var titleAddMore: UILabel!
    
    @IBOutlet weak var fieldPurse: JSInputField!
    
    @IBOutlet weak var checkMorePurses: UIButton!
    
    @IBOutlet weak var table: UITableView!

    
    //MARK: - Views Load override
    
    override func loadMainSubViews() {
 
        setTextField()
        
        fillWithData()

    }
    
    
    override func stopAllSchedule(){
       
     fieldPurse.resignFirstResponder()
        
    }
     
    //MARK: -

    func setTextField(){
        
        fieldPurse.initialize()
        fieldPurse.floatingLabelTextColor = UIColor.uuLightPeach
        fieldPurse.text = kEmpty
        
    }
    
    
    func fillWithData(){
        
        attentionText.text = TR("attention_text")
        titleAddMore.text = TR("add_wallet_address")
        titleMain.text = TR("your_wallets")
        fieldPurse.placeholder = TR("your_wallet_address")
        checkMorePurses.setTitle(TR("add") + " +", for: .normal)
    }
    
    
    
    //MARK: - UITextFieldDelegate
    
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if isAddressEth(updatedText){
                
                textField.textColor =  UIColor.white
                
            } else {
                
                textField.textColor = UIColor.red
            }
            
            
        }

        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField.text != nil {
            
            onAddnewLine()
        }
        
        return true
    }
    
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users_account_wallets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "id_cell")
        
        if (cell == nil)
        {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "id_cell")
        }

        setCellBody(cell!,indexPath)
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        saveToClipboard(getKeyOfMyWallet(indexPath.row))
    
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete

    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        removeKeyfromMyWallet(indexPath.row)
        
        MemoryControll.saveWalletsInMemory()

        tableView.endUpdates()
        
    }
    
    //MARK: - On Buttons
    
 
    func checkForExit(){
        
        fieldPurse.text = nil
        fieldPurse.resignFirstResponder()
        
        if exitAsPopUp == 2 {
            (current_controller_core as? ProfileViewController)?.onGoToGames()
        }
    }
  
    func onAddnewLine(){
 
        sendEvent("EVENT_WALLET_ADD")
        
        if fieldPurse.text != nil {
           
            if isAddressEth(fieldPurse.text!){
                
                if !isMywalletHasTheNumber(fieldPurse.text!){
                    
                    current_controller_core?.showActivityViewIndicator()
                    
                    let wallet = Wallet()
                    wallet.smart_contract_id = fieldPurse.text!

                    users_account_wallets.insert(wallet, at: 0)
                    
                    NetWork.getWalletsOfUserInGames(completion: { (error : String?) in
                        
                        self.table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
                        
                        MemoryControll.saveWalletsInMemory()
                        current_controller_core?.hideActivityViewIndicator()
                        
                        self.checkForExit()
                    })
                    
                } else {
                    
                    checkForExit()
                    
                }



            } else {
                // wrong format
            }

        } else {
            // empty text was
        }
        
    }

    
    @IBAction func onAddMorePurse(){
        
        onAddnewLine()
        
//        if fieldPurse.isFirstResponder {
//            fieldPurse.resignFirstResponder()
//        } else {
//            fieldPurse.becomeFirstResponder()
//        }
        
    }
    
    
    @IBAction func onQrScan(_ sender : Any){
        
        current_controller_core?.onQRScan(sender)
     }
    
    @objc func onGoToGames(){
        
        current_controller_core?.goToMainView(getTabBarTag())

    }
    
    
    
    func onQRAnswer(_ haveText : String?){
        if let text = haveText{
            fieldPurse.text = text
        }
        
    }
    
    
    //MARK:-  UITableViewCell

    func setCellBody(_ cell : UITableViewCell, _ indexPath : IndexPath) {
 
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        
        for viewItem in cell.contentView.subviews {
            viewItem.removeFromSuperview()
        }
        let heightOfFon : CGFloat = 50
        
        
        let fon = UIView(frame:CGRect(x: 0, y: 0,
                                      width:  table.frame.width,
                                      height: heightOfFon))
        fon.backgroundColor = kColorDarkBlue
        fon.layer.cornerRadius = 8
        cell.contentView.addSubview(fon)
 
        let keyWallet = getKeyOfMyWallet(indexPath.row)
        
        let games = users_account_wallets[indexPath.row].active_games
        
        for i in 0..<games.count {
            let gameType = getGameType(games[i])
            if gameType != kTypeUndefined {
                addGameItem(fon, imageNum: gameType, order: i)
            }
        }
 
        addLine(fon, keyWallet, widthShift : ( fon.frame.height * 0.6) * CGFloat(games.count) + 15)
   
    }

    func addLine(_ fon : UIView,_ text: String, widthShift : CGFloat ){

        let  first = UILabel(frame: CGRect(x: widthShift, y: 0,
                                           width:  fon.frame.width - widthShift - 15,
                                           height: fon.frame.height))
        first.tag = 10
        first.text = text
        first.textColor = UIColor.white
        first.textAlignment = .left
        first.backgroundColor = UIColor.clear
        first.font = UIFont(name: kFont_Light, size: 16)
        first.adjustsFontSizeToFitWidth = true
        first.isUserInteractionEnabled = false
        fon.addSubview(first)
        
    }
    
    
    func addGameItem(_ fon : UIView, imageNum : Int, order : Int ){
 
        let heightOfItem  = fon.frame.height * 0.6
        let height   = heightOfItem * 0.6

        let  itemGame = UIImageView(frame: CGRect(x: heightOfItem * CGFloat(order) + 15 ,
                                                  y: (fon.frame.height - height) / 2,
                                                  width: height,
                                                  height: height))
        
        let imageOrder = kTypeTabBarOrder.index(of: imageNum)!
        itemGame.image = UIImage(named :  lottery_images[imageOrder])
        itemGame.contentMode = .scaleAspectFit
        itemGame.tag = 100 * order
        itemGame.contentMode = .scaleAspectFit
        itemGame.backgroundColor = UIColor.clear
        itemGame.tintColor = kColorLightGray
        itemGame.clipsToBounds = true
        fon.addSubview(itemGame)

        
    } 
}
