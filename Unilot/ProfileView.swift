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


class ProfileView: ControllerCore, UITextFieldDelegate {
    
    @IBOutlet weak var titleMain: UILabel!

    @IBOutlet weak var titleResult: UILabel!

    @IBOutlet weak var fieldPurse: JSInputField!

    @IBOutlet weak var nickName: UITextField!

    @IBOutlet weak var checkMorePurses: UIButton!

    @IBOutlet weak var answerRect: UIView!
    
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    
    //MARK: - Views Load override
    
    override func viewDidLoad() {
        
        super.viewDidLoad() 
        
        setBorders()
        
        setTextField()
        
        hideNewNick()
        
        fillWithData()
        
    }
  
    func setTextField(){

        fieldPurse.initialize()
        fieldPurse.floatingLabelTextColor = UIColor.gray
        fieldPurse.text = kEmpty
        
        let viewTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(ProfileView.handleViewTap(recognizer:)))

        viewTapGestureRec.cancelsTouchesInView = false
        self.view.addGestureRecognizer(viewTapGestureRec)
        
    }
 
    func setBorders(){
        checkMorePurses.layer.borderWidth = 1
        checkMorePurses.layer.borderColor = UIColor.white.cgColor
        checkMorePurses.layer.cornerRadius = checkMorePurses.frame.height/2
        
        answerRect.layer.borderWidth = 1
        answerRect.layer.borderColor = UIColor.green.cgColor
    }
    

    
    func hideNewNick(){
        answerRect.isHidden = true

    }
    
    func fillNewNick(){
        answerRect.isHidden = false
        nickName.text = "weifuybUYTR&^G"
    }
    
    func fillWithData(){
        titleMain.text = TR("Получите\nуникальный никнейм")
        fieldPurse.placeholder = TR("Номер вашего кошелька")
        checkMorePurses.setTitle(TR("Добавить еще один кошелек"), for: .normal)
        titleResult.text = TR("Отлично!\nКошельку присвоен никнейм")

    }
    
    
    @IBAction func onAddMorePurse(){
        
        fieldPurse.text = ""
        
        fieldPurse.becomeFirstResponder()

        hideNewNick()

    }
    
    @IBAction func onQRScan(_ sender: Any) {
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
          
            if let text = result?.value{
                self.fieldPurse.text = text
                self.fillNewNick()
            }

            self.dismiss(animated: true, completion: nil)

        }
        
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        
        present(readerVC, animated: true, completion: nil)
        
    }
    
    //MARK: - UITextFieldDelegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        fillNewNick()

//        showActivityViewIndicator()


        return true
    }
   
    func handleViewTap(recognizer: UIGestureRecognizer) {
        fieldPurse.resignFirstResponder()
    }
 

}
