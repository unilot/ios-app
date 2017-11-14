//
//  ProfileSubView.swift
//  Unilot
//
//  Created by Alyona on 11/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import SCLAlertView


class ProfileSubView: OnScrollItemCore, UITextFieldDelegate,  UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var titleAddMore: UILabel!
    
    @IBOutlet weak var fieldPurse: JSInputField!
    
    @IBOutlet weak var checkMorePurses: UIButton!
    
    @IBOutlet weak var table: UITableView!
    
     
    //MARK: - Views Load override
    
    override func didLoad(_ indexNum: Int) {
 
        // clean from XIB
        super.didLoad(indexNum)
        
        setTextField()
        
        fillWithData()

        addTouchForKeyBoard()

    }
    
    //MARK: - keyboard
    
    
    func addTouchForKeyBoard(){
        
        let viewTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(ProfileSubView.handleViewTap(recognizer:)))
        
        viewTapGestureRec.cancelsTouchesInView = false
        self.addGestureRecognizer(viewTapGestureRec)
        
    }
    
    func handleViewTap(recognizer: UIGestureRecognizer) {
        
        fieldPurse.resignFirstResponder()
        
    }
    
    override func onUserCloseView(){

        fieldPurse.resignFirstResponder()

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
        return 50
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
        
        if let cell = sender.superview?.superview as? UITableViewCell{
            currentTagForRemove = table.indexPath(for: cell)!.row
            
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: kFont_Regular, size: 20)!,
                kTextFont: UIFont(name: kFont_Light, size: 14)!,
                kButtonFont: UIFont(name: kFont_Bold, size: 14)!,
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton(TR("Yes"), target:self, selector: #selector(ProfileView.onDelete))
            alertView.addButton(TR("No")) {
                self.currentTagForRemove = -1
            }
            
            let keyCurrent = users_account_number[currentTagForRemove]
            
            alertView.showWarning("", subTitle: TR("question_for_delete") + keyCurrent + "?")
            
        }
        
        
    }
    
    
    func onDelete(){
        
        if currentTagForRemove >= 0 {
            
            users_account_number.remove(at: currentTagForRemove)
            table.deleteRows(at: [IndexPath(row: currentTagForRemove, section: 0)],
                             with: .top)
            
            saveDataInMemory()
            currentTagForRemove = -1
        }
    }
    
    func onAddnewLine(){
        
        if fieldPurse.text != nil {
            users_account_number.insert(fieldPurse.text!, at: 0)
            
            table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
            
            saveDataInMemory()
            
            fieldPurse.text = nil
        }
        
    }
    
    @IBAction func onAddMorePurse(){
        
        onAddnewLine()
        
        fieldPurse.becomeFirstResponder()
        
    }
    
    
    
    
    func onQRAnswer(_ haveText : String?){
        if let text = haveText{
            fieldPurse.text = text
        }
        
    }
    //MARK:-  UITableViewCell
    
    
    func createCellBody(_ cell : UITableViewCell) {

        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let frame = cell.contentView.frame
        
        var fon = cell.contentView.viewWithTag(5) as? UIImageView
        
        if fon == nil{
            
            fon = UIImageView(frame: CGRect(x: 5, y: 2,
                                          width:  frame.width  - 10,
                                          height: frame.height - 4))
            fon!.tag = 5
            fon!.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            fon!.layer.cornerRadius = 8
            cell.contentView.addSubview(fon!)

        }
        
        var first = cell.contentView.viewWithTag(10) as? UILabel
        
        if first == nil{
        
            first = UILabel(frame: CGRect(x: 15, y: 0,
                width:  frame.width - 15 - frame.height, height: frame.height))
            first!.tag = 10
            first!.textColor = UIColor.white
            first!.textAlignment = .left
            first!.backgroundColor = UIColor.clear
            first!.font = UIFont(name: kFont_Light, size: 16)
            first!.adjustsFontSizeToFitWidth = true
            cell.contentView.addSubview(first!)
        }
        
        
        var button_x = cell.contentView.viewWithTag(20) as? MyButton
        
        if button_x == nil{
            button_x = MyButton(frame: CGRect(x: frame.width - 50, y: (frame.height - 40)/2,
                                          width: 40, height: 40))

            button_x!.setImage(UIImage(named : "X-x3"), for: .normal)
            button_x!.tag = 20
            button_x!.addTarget(self, action: #selector(ProfileSubView.onIks(_:)), for: .touchUpInside)
            button_x!.imageView?.contentMode = .scaleAspectFit
            button_x!.imageView?.backgroundColor = UIColor.clear
            button_x!.backgroundColor = UIColor.clear
            button_x!.imageView?.tintColor = kColorLightGray
            button_x!.imageView?.clipsToBounds = true
            cell.contentView.addSubview(button_x!)

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
