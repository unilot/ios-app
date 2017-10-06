//
//  ProfileView.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

class ProfileView: ControllerCore, UITextFieldDelegate {
    
    @IBOutlet weak var titleMain: UILabel!

    @IBOutlet weak var titleResult: UILabel!

    @IBOutlet weak var fieldPurse: JSInputField!

    @IBOutlet weak var nickName: UITextField!

    @IBOutlet weak var checkMorePurses: UIButton!

    @IBOutlet weak var answerRect: UIView!
    
    //MARK: - Views Load override
    
    override func viewDidLoad() {
        
        super.viewDidLoad() 
         
        setBorders()
        
        setTextField()
        
        fillWithData()
        
        answerRect.isHidden = true
    }
 
    
    func setTextField(){
        fieldPurse.initialize()
        fieldPurse.floatingLabelTextColor = UIColor.gray
        fieldPurse.text = kEmpty
    }
 
    func setBorders(){
        checkMorePurses.layer.borderWidth = 1
        checkMorePurses.layer.borderColor = UIColor.white.cgColor
        checkMorePurses.layer.cornerRadius = checkMorePurses.frame.height/2
        
        answerRect.layer.borderWidth = 1
        answerRect.layer.borderColor = UIColor.green.cgColor
    }
    
    func fillWithData(){
        titleMain.text = TR("Получите\nуникальный никнейм")
        fieldPurse.placeholder = TR("Номер вашего кошелька")
        checkMorePurses.setTitle(TR("Добавить еще один кошелек"), for: .normal)
    }
    
    func fillNewNick(){
        answerRect.isHidden = false
        titleResult.text = TR("Отлично!\nКошельку присвоен никнейм")
        nickName.text = "weifuybUYTR&^G"
        nickName.isEnabled = false
    }
    
    
    @IBAction func onAddMorePurse(){
                
        fillNewNick()

    }
    
    //MARK: - UITextFieldDelegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        showActivityViewIndicator()


        return true
    }
   
}
