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


class ProfileView: ControllerCore, UITextFieldDelegate,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleMain: UILabel!

    @IBOutlet weak var fieldPurse: JSInputField!

    @IBOutlet weak var checkMorePurses: UIButton!

    @IBOutlet weak var table: UITableView!

    
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
        
        fillWithData()
                
    }
    
    override func addMenuButton() {
        
        tabBarController?.navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    override func addSwipeForMenuOpen(){
        
 
    
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

    }
    
 
    func fillWithData(){
        titleMain.text = TR("Получите\nуникальный никнейм")
        fieldPurse.placeholder = TR("Номер вашего кошелька")
        checkMorePurses.setTitle(TR("Добавить еще один кошелек"), for: .normal)
    }
    
    
    @IBAction func onAddMorePurse(){
        
        fieldPurse.text = ""
        
        fieldPurse.becomeFirstResponder()

    }
    
    @IBAction func onQRScan(_ sender: Any) {
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
          
            if let text = result?.value{
                self.fieldPurse.text = text
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
        
        if textField.text != nil {
            my_tokens.insert(textField.text!, at: 0)
            
            table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
            
            textField.text = nil

        }

        return true
    }
   
    func handleViewTap(recognizer: UIGestureRecognizer) {
        fieldPurse.resignFirstResponder()
    }
 

    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return my_tokens.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.layoutIfNeeded()
        
        cell.contentView.backgroundColor = UIColor.black
        
        labelFor(cell,10)?.text = my_tokens[indexPath.row]
        
        
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
        saveToClipboard(my_tokens[indexPath.row])
    }
    
    
    func onIks(_ sender: MyButton){
        
        my_tokens.remove(at: sender.subTag!.row)
        table.deleteRows(at: [sender.subTag!], with: .top)
    
    }
    

}
