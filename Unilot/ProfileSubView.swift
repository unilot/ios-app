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

class ProfileViewController: ControllerCore {
    
    var profile_tab : ProfileSubView!

     override func setTitle() {
 
        navigationItem.title = " "
        
        sendEvent("EVENT_PROFIL")
    }
    
    
    override func onInfoBarButton(){
        
        onShowWalletsAlert()
        
    }

    
    //MARK: - Views Load override

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        profile_tab.stopAllSchedule()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.clipsToBounds = true

        setNavControllerClear()
        
        setFon()
        
        setTitle()
        
        addMenuButton()
        
        addInfoButton()
        
        
    }


    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
 
        addMainView()
        
        if open_from_notif == default_first_launch {
            
            open_from_notif = nil
            
            onInfoBarButton()
        }
    }
    
    
    
    
    func addMainView(){
  
        current_controller_core = self

        profile_tab = getFromNib("ProfileView") as! ProfileSubView
        profile_tab.frame = CGRect(x: 0, y: getStatusbarShift() / 2, width: view.frame.width, height: view.frame.height)
        profile_tab.didLoad(0)
        profile_tab.revealPlayButton()
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
        
        current_controller_core?.goToMainView(getTabBarTag())
        
    }
    
    //MARK: - size text
    
    

    
    
}

class ProfileSubView: OnScrollItemCore, UITextFieldDelegate,  UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var letsPlay: UIButton!

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
    
    func revealPlayButton(){
        
        var opacity : Float!
        var isUserInteraction : Bool!
        
        if users_account_number.count > 0 {
            
            opacity = 1.0
            isUserInteraction = true
 
        } else {

            opacity = 0.0
            isUserInteraction = false

        }
        
        UIView.animate(withDuration: 1, animations: {
            self.letsPlay.layer.opacity = opacity
            self.letsPlay.isUserInteractionEnabled = isUserInteraction
        })
    }
     
    //MARK: -

    func setTextField(){
        
        fieldPurse.initialize()
        fieldPurse.floatingLabelTextColor = UIColor.uuLightPeach
        fieldPurse.text = kEmpty
        
    }
    
    
    func fillWithData(){
        
        titleAddMore.text = TR("add_wallet_address")
        titleMain.text = TR("your_wallets")
        fieldPurse.placeholder = TR("your_wallet_address")
        checkMorePurses.setTitle(TR("add") + " +", for: .normal)
        letsPlay.setTitle(TR("lets_start"), for: .normal)
        letsPlay.addTarget(current_controller_core!,
                           action: #selector(ProfileViewController.onGoToGames),
                           for: .touchUpInside)
    }
    
    
    
    //MARK: - UITextFieldDelegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        onAddnewLine()
        
        return true
    }
    
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users_account_number.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "id_cell")
        
        if (cell == nil)
        {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "id_cell")
            
            createCellBody(cell!)
            
        }

        setCellBody(cell!,indexPath)
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveToClipboard(users_account_number[indexPath.row])
    }
    
    
    
    
    //MARK: - On Buttons
    
    var currentTagForRemove : Int = -1
    
    func onIks(_ sender: MyButton){
        
        if let cell = sender.superview?.superview?.superview as? UITableViewCell{
            
            currentTagForRemove = table.indexPath(for: cell)!.row
            
            let keyCurrent = users_account_number[currentTagForRemove]
            
            SweetAlert().showAlert(" ", subTitle: TR("question_for_delete") + keyCurrent + "?", style: AlertStyle.warning, buttonTitle: TR("No"),
                                   buttonColor: kColorNormalGreen ,
                                   otherButtonTitle: TR("Yes"),
                                   otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    self.currentTagForRemove = -1
                }
                else {
                    
                    SweetAlert().showAlertDeletedComplete()
                    self.onDelete()
                 }
            }
            
        }
         
    }
    
    
    func onDelete(){
        
        if currentTagForRemove >= 0 {
            
            users_account_number.remove(at: currentTagForRemove)
            table.deleteRows(at: [IndexPath(row: currentTagForRemove, section: 0)],
                             with: .top)
            
            saveDataInMemory()
            currentTagForRemove = -1
            revealPlayButton()
        }
    }
    
    func onAddnewLine(){
        
        sendEvent("EVENT_WALLET_ADD")
        
        if fieldPurse.text != nil {
            users_account_number.insert(fieldPurse.text!, at: 0)
            
            table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
            
            saveDataInMemory()
            
            fieldPurse.text = nil
            
            revealPlayButton()

        }
        
    }
    
    @IBAction func onAddMorePurse(){
        
        onAddnewLine()
        
        fieldPurse.becomeFirstResponder()
        
    }
    
    
    @IBAction func onQrScan(_ sender : Any){
        
        current_controller_core?.onQRScan(sender)
    }
    
    @IBAction func onGoToGames(_ sender : Any){
        
        current_controller_core?.goToMainView(getTabBarTag())

    }
    
    
    
    func onQRAnswer(_ haveText : String?){
        if let text = haveText{
            fieldPurse.text = text
        }
        
    }
    //MARK:-  UITableViewCell
    
    
    func createCellBody(_ cell : UITableViewCell) {
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none

        let fon_frame =  CGRect(x: 0, y: 0,
                                width:  table.frame.width,
                                height: 50)
        
        var fon = cell.contentView.viewWithTag(5)
        
        if fon == nil{
            
            fon = UIView(frame:fon_frame)
            fon!.tag = 5
            fon!.backgroundColor = kColorDarkBlue
            fon!.layer.cornerRadius = 8
            cell.contentView.addSubview(fon!)

        }
        
        var first = cell.contentView.viewWithTag(10) as? UILabel
        
        if first == nil{
        
            first = UILabel(frame: CGRect(x: 15, y: 0,
                width:  fon_frame.width - 15 - fon_frame.height, height: fon_frame.height))
            first!.tag = 10
            first!.textColor = UIColor.white
            first!.textAlignment = .left
            first!.backgroundColor = UIColor.clear
            first!.font = UIFont(name: kFont_Light, size: 16)
            first!.adjustsFontSizeToFitWidth = true
            first!.isUserInteractionEnabled = false
            fon!.addSubview(first!)
        }
        
        
        var hiddenIkx = cell.contentView.viewWithTag(15) as? UIImageView
        
        if hiddenIkx == nil{
            hiddenIkx = UIImageView(frame: CGRect(x: fon_frame.width - 30,
                                              y: (fon_frame.height - 20)/2,
                                          width: 20, height: 20))

            hiddenIkx!.image = UIImage(named : "X-x3")
            hiddenIkx!.tag = 15
            hiddenIkx!.contentMode = .scaleAspectFit
            hiddenIkx!.backgroundColor = UIColor.clear
            hiddenIkx!.tintColor = kColorLightGray
            hiddenIkx!.clipsToBounds = true
            fon!.addSubview(hiddenIkx!)

        }

        var button_x = cell.contentView.viewWithTag(20) as? MyButton
        
        if button_x == nil{
            button_x = MyButton(frame: CGRect(x: fon_frame.width - fon_frame.height, y: 0,
                                              width: fon_frame.height, height: fon_frame.height))
            button_x!.tag = 20
            button_x!.addTarget(self, action: #selector(ProfileSubView.onIks(_:)), for: .touchUpInside)
            button_x!.imageView?.contentMode = .scaleAspectFit
            button_x!.imageView?.backgroundColor = UIColor.clear
            button_x!.backgroundColor = UIColor.clear
            button_x!.imageView?.clipsToBounds = true
            fon!.addSubview(button_x!)
            
        }
        
        
    }
    
    func setCellBody(_ cell : UITableViewCell, _ indexPath : IndexPath) {
        
        
        if let first = cell.contentView.viewWithTag(10) as? UILabel {
            first.text = users_account_number[indexPath.row]
        }
 
        if let button_x = cell.contentView.viewWithTag(20) as? MyButton {
            button_x.subTag = indexPath
        }
    
    }
    
    
    //MARK: - exit

    
    func saveDataInMemory(){
        
        MemoryControll.saveObject(users_account_number, key: "users_account_number")
        
    }
}
