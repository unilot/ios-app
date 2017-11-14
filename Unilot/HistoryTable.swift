//
//  HistoryTable.swift
//  Unilot
//
//  Created by Alyona on 10/9/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import Foundation
import SCLAlertView



class HistoryTable: ControllerCore, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var table: UITableView!

    var currentTable = 1
    
    var dataForSegment: [[GameInfo]] = [[],[],[]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fillSegmentNames()
        
        table.layer.opacity = 0.0
        
        showActivityViewIndicator()

        NetWork.getHistoryPage(completion: onAnswer)
        
        
     }
     
    
    func onAnswer(_ error : String?){
        
        hideActivityViewIndicator()
        
        if error != nil{
            
            SCLAlertView().showError(" ", subTitle: error!)
            
        } else {
            
           onFillDataForSegment()
            
        }
        
        table.reloadData()
        
        setTableHeader()
        
        UIView.animate(withDuration: 0.5) {
            
            self.table.layer.opacity = 1.0
            
        }
    }
    
    override func setTitle() {
        
        navigationItem.title = TR("history_of_drawings")
    
    }
    
    //MARK:-  segment
    
    
    func fillSegmentNames(){
        
        for i in 1..<4 {
            
            let uibutton = view.viewWithTag(i*100) as! UIButton
            uibutton.addTarget(self, action: #selector(HistoryTable.onSegmentChange(_:)), for: .touchUpInside)
            
            let image = view.viewWithTag(i*100+1) as! UIImageView
            image.tintColor =  currentTable == (i-1) ? kColorLightOrange : UIColor.black

            let label = view.viewWithTag(i*100+2) as! UILabel
            label.text =  TR(tabbar_strings[i-1]).capitalized
            label.textColor = currentTable == (i-1) ? kColorLightOrange : UIColor.black
        }

    }

    
    func onFillDataForSegment(){
        
        for i in 0..<3 {
            dataForSegment[i] = history_list.filter({return $0.type == kTypeTabBarOrder[i]})
        }

    }
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForSegment[currentTable].count
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func setTableHeader(){
        
        let header_view = table.tableHeaderView!
        
        if let label = header_view.viewWithTag(10) as? UILabel{
            label.text = TR("date_drawing").uppercased()
        }
        
        if let label = header_view.viewWithTag(20) as? UILabel{
            label.text = TR("status").uppercased()
        }
        
        if let label = header_view.viewWithTag(30) as? UILabel{
            label.text = TR("prize").uppercased()
        }
    
    }
 
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
        
        cell.layoutIfNeeded()
        
        let item = dataForSegment[currentTable][indexPath.row]
        
        if let img = cell.contentView.viewWithTag(10) as? SpecialItem{
            img.image = UIImage(named: kTypeImage[item.type]! + "-template")
            img.tintColor = kColorHistoryGray
            img.setCircleMark(item.game_id)
        }
        

        labelFor(cell, 20)?.text = getNiceDateFormatHistoryString(from: item.ending_at)
 
        let actionLabel  =   labelFor(cell, 30)!
        let button = cell.contentView.viewWithTag(40) as! MyButton
        
        button.setTitle(item.smart_contract_id, for: .normal)
        button.subTag = indexPath
        button.isUserInteractionEnabled = false
//      button.addTarget(self, action: #selector(HistoryTable.onContractId(sender:)), for: .touchUpInside)
 
        switch item.status {
            
        case kStatusComplete:
            actionLabel.text = TR("finished")
            button.setTitle(TR("list_of_winners"), for: .normal)
            button.setTitleColor(kColorSelectedBlue, for: .normal)
            break
            
        case kStatusPublished , kStatusFinishing:
            actionLabel.text = TR("in_process")
            button.setTitle(TR("open"), for: .normal)
            button.setTitleColor(kColorNormalGreen, for: .normal)
             break
         
        default: //kStatusCancele
            actionLabel.text = TR("canceled")
            button.setTitle(TR(" "), for: .normal)
            button.setTitleColor(kColorLightOrange, for: .normal)
            break
        }
        
        
        // decor
        if let fon = cell.contentView.viewWithTag(5) as? UIImageView{
            
            if indexPath.row % 2 == 0 {
                fon.backgroundColor = kColorLightGray
            } else {
                fon.backgroundColor = UIColor.white
            }

            fon.layer.cornerRadius = fon.frame.height/2
        }
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        local_current_game = dataForSegment[currentTable][indexPath.row]
         
        NotifApp.removeNotifWithSameGameId(local_current_game.game_id)
        
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        switch local_current_game.status {
            
        case kStatusComplete:
            
            onDetails()

            
        case kStatusPublished:

            goToMainView(getTabBarTag())

        default: //kStatusCancel
            
            break
        }
        
    }
 
    
    //MARK: - onBUttons
    
    
    func onSegmentChange(_ button : UIButton){
        
        currentTable = button.tag/100 - 1

        fillSegmentNames()
        
        table.layer.opacity = 0.0
        
        table.reloadData()
        
        UIView.animate(withDuration: 0.3) {
            
            self.table.layer.opacity = 1.0
            
        }
    
    }
 
    
    func onDetails(){
        
        performSegue(withIdentifier: "sigue_details", sender: self)
        
    }
    
 
    

}
