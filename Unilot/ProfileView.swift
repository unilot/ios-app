//
//  ProfileView.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import SCLAlertView


class ProfileView: ControllerCore, UITextFieldDelegate,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleMain: UILabel!

    @IBOutlet weak var titleAddMore: UILabel!

    @IBOutlet weak var fieldPurse: JSInputField!

    @IBOutlet weak var checkMorePurses: UIButton!

    @IBOutlet weak var table: UITableView!


    
    //MARK: - Views Load override
    
    override func viewDidLoad() {
        
        super.viewDidLoad() 
        
        view.backgroundColor = UIColor.clear
        
        
        setBorders()
        
        setTextField()
        
        addTouchForKeyBoard()
        
        fillWithData()

        itemBadge?.setNumberLabel(notifications_data["badge"]!)

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentTabBarLottery = tabBarItem.tag
    } 
    
    
    override func setBackButton(){
     
        addMenuButton()

        
    }
    
    override func addSwipeForMenuOpen(){
        
 
    
    }
  
    func setTextField(){

        fieldPurse.initialize()
        fieldPurse.floatingLabelTextColor = UIColor.uuLightPeach
        fieldPurse.text = kEmpty
        
    }

 
    func setBorders(){
//        checkMorePurses.layer.borderWidth = 1
//        checkMorePurses.layer.borderColor = UIColor.white.cgColor
//        checkMorePurses.layer.cornerRadius = checkMorePurses.frame.height/2

    }
    
 
    func fillWithData(){
        titleAddMore.text = TR("Добавить кошелёк")
        titleMain.text = TR("Ваши кошельки")
        fieldPurse.placeholder = TR("Номер вашего кошелька")
        checkMorePurses.setTitle(TR("Добавить") + " +", for: .normal)
    }
     

    
    //MARK: - UITextFieldDelegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        onAddnewLine()
        
        return true
    }
   
    override  func answerFromKeyBoardClosed(){
        fieldPurse.resignFirstResponder()

    }
 

    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users_account_number.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.layoutIfNeeded()
        
        labelFor(cell,10)?.text = users_account_number[indexPath.row]
        
        
        if let button_x = cell.contentView.viewWithTag(20) as? MyButton{
            button_x.subTag = indexPath
            button_x.addTarget(self, action: #selector(ProfileView.onIks(_:)), for: .touchUpInside)
            button_x.imageView?.contentMode = .scaleAspectFit
            button_x.imageView?.backgroundColor = UIColor.clear
            button_x.imageView?.tintColor = kColorLightGray
            button_x.imageView?.clipsToBounds = true
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveToClipboard(users_account_number[indexPath.row])
    }
    



    //MARK: - On Buttons
    
    var currentTagForRemove : Int = -1
    
    func onIks(_ sender: MyButton){
        
        if let cell = sender.superview?.superview as? UITableViewCell{
            currentTagForRemove = table.indexPath(for: cell)!.row
            
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: kFont_Regular, size: 20)!,
                kTextFont: UIFont(name: kFont_Light, size: 14)!,
                kButtonFont: UIFont(name: kFont_Bold, size: 14)!,
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)

            alertView.addButton(TR("Да"), target:self, selector: #selector(ProfileView.onDelete))
            alertView.addButton(TR("Нет")) {
                self.currentTagForRemove = -1
            }
            
            let keyCurrent = users_account_number[currentTagForRemove]

            alertView.showWarning("", subTitle: TR("Вы уверены что хотите удалить ключ ") + keyCurrent + "?")
            
        }
        
        
    }
    
    
    func onDelete(){
        
        if currentTagForRemove >= 0 {
            
            users_account_number.remove(at: currentTagForRemove)
            table.deleteRows(at: [IndexPath(row: currentTagForRemove, section: 0)],
                             with: .top)
         
            currentTagForRemove = -1
        }
    }
    
    func onAddnewLine(){
       
        if fieldPurse.text != nil {
            users_account_number.insert(fieldPurse.text!, at: 0)
            
            table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
            
            fieldPurse.text = nil
        }

    }
    
    @IBAction func onAddMorePurse(){
        
        onAddnewLine()
        
        fieldPurse.becomeFirstResponder()
        
    }
    

    
    override func onQRAnswer(_ haveText : String?){
        if let text = haveText{
             fieldPurse.text = text
        }
        
    }

    //MARK: - exit

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        fieldPurse.resignFirstResponder()
        
        MemoryControll.saveObject(users_account_number, key: "users_account_number")
        
    }
}
