//
//  HistoryTable.swift
//  Unilot
//
//  Created by Alyona on 10/9/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit



class HistoryTable: ControllerCore, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var table: UITableView!

    
    var dataForTable =
    [
    ["0","0","10.10.17","в процессе","перейти"],
    ["0","1","10.10.17","в процессе","перейти"],
    ["0","2","10.10.17","в процессе","перейти"],
    ["1","1","10.10.17","завершена","список победителей"],
    ["1","2","10.10.17","завершена","список победителей"],
    ["1","0","10.10.17","завершена","список победителей"],
    ["1","1","10.10.17","завершена","список победителей"],
    ["1","1","10.10.17","завершена","список победителей"],
    ["1","2","10.10.17","завершена","список победителей"],
    ["1","0","10.10.17","завершена","список победителей"],
    ["1","2","10.10.17","завершена","список победителей"],
    ["1","1","10.10.17","завершена","список победителей"],
    
    ]
    
    
    
    
//    var dataForTable = [87687,87687,987987,9,87,98,09,98,98,9,8,8,8,98,98,9,9,9]//[String]()
    var viewWithPlaces : TotalPrizeFond? = nil
  
    
    override func setTitle() {
        notifications_data =  ["badge" : 0]
        navigationItem.title = "История ваших розыгрышей"
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
        
        labelFor(cell, 20)?.text = item[2]
        labelFor(cell, 30)?.text = item[3]

        if let img = cell.contentView.viewWithTag(10) as? UIImageView{
            img.image = UIImage(named: lottery_images[Int(item[1])!])
        }
        
        let label  =   labelFor(cell, 40)!

        label.text = item[4]
        
        if item[0] == "1" {
            label.textColor = kColorSelectedBlue
        } else {
            label.textColor = kColorNormalGreen
        }
        
        
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
        
        let item = dataForTable[indexPath.row]

        if item[0] == "1" {
            onDetails()
        } else{
            
            currentTabBarLottery  =  Int(item[1])!
            
            goToMainView()
        
        }
        
    }
 
    
    func onDetails(){
        performSegue(withIdentifier: "sigue_details", sender: self)
        
    }
    
 
    

}
