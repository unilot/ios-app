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
    
    var dataForTable = [GameInfo]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        table.layer.opacity = 0.0
        
        showActivityViewIndicator()
        
        NetWork.getHistoryPage(completion: onAnswer)
        
    }
    
    func onAnswer(_ error : String?){
        
        hideActivityViewIndicator()
        
        if error != nil{
            
//            SCLAlertView().showError(" ", subTitle: error!)

            dataForTable = [
                games_list[kTypeDay]!,
                games_list[kTypeDay]!,
                games_list[kTypeDay]!,
                games_list[kTypeDay]!,
                games_list[kTypeDay]!,
                games_list[kTypeWeek]!,
                games_list[kTypeDay]!,
                games_list[kTypeDay]!,
                games_list[kTypeDay]!,
                games_list[kTypeMonth]!
            ]
            
            
        } else {
            
            dataForTable =  history_list.sorted(by: {  return $0.started_at > $1.started_at})

        }
        
        table.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            
            self.table.layer.opacity = 1.0
            
        }
    }
    
    
    
    var viewWithPlaces : TotalPrizeFond? = nil
    
    override func setTitle() {
        notifications_data =  ["badge" : 0]
        navigationItem.title = TR("История ваших розыгрышей")
    }
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForTable.count
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: view.frame.width * 0.9,
                                              height: 44))
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "id_header")!        
      

        headerCell.contentView.frame  = headerView.frame
        
        headerView.addSubview(headerCell)
       
        labelFor(headerCell, 10)?.text = TR("ДАТА И ЛОТЕРЕЯ")
        labelFor(headerCell, 20)?.text = TR("СТАТУС")
        labelFor(headerCell, 30)?.text = TR("ВЫИГРЫШ")
        

        headerView.layoutIfNeeded()
        
        return headerView
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
        
        cell.layoutIfNeeded()
        
        let item = dataForTable[indexPath.row]
        
        if let img = cell.contentView.viewWithTag(10) as? UIImageView{
            img.image = UIImage(named: kTypeImage[item.type]!)
        }
        
        labelFor(cell, 20)?.text = getNiceDateFormatString(from: item.started_at)
 
        let actionLabel  =   labelFor(cell, 30)!
        let statusLabel  =   labelFor(cell, 40)!
        
        switch item.status {
            
        case kStatusComplete:
            actionLabel.text = TR("завершена")
            statusLabel.text = TR("список победителей")
            statusLabel.textColor = kColorSelectedBlue
            
        case kStatusPublished:
            actionLabel.text = TR("в процессе")
            statusLabel.text = TR("перейти")
            statusLabel.textColor = kColorNormalGreen
            
        default: //kStatusCancele
            actionLabel.text = TR("отменена")
            statusLabel.text = " "
            statusLabel.textColor = kColorLightOrange
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
        
        local_current_game = dataForTable[indexPath.row]
        
        switch local_current_game.status {
            
        case kStatusComplete:
            onDetails()

            
        case kStatusPublished:
            
            currentTabBarLottery  =  kTypeTabBarOrder.index(of: local_current_game.type)!
            
            goToMainView()

        default: //kStatusCancele
            
            break
        }
        
    }
 
    
    func onDetails(){
        
        performSegue(withIdentifier: "sigue_details", sender: self)
        
    }
    
 
    

}
