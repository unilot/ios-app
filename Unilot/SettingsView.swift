//
//  SettingsView.swift
//  Unilot
//
//  Created by Alyona on 10/12/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit


class SettingsView: ControllerCore, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var table: UITableView!
    


    var viewWithPlaces : TotalPrizeFond? = nil
    
 
    
    override func setTitle() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        navigationItem.title = TR("settings")
        
        sendEvent("EVENT_SETTINGS")
    }
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting_strings[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: tableView.frame.width,
                                              height: 50))
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "id_header")!
        headerView.addSubview(headerCell)
        
        switch section {
        case 0:
            labelFor(headerCell, 20)?.text = TR("get_notifications_for")

        default:
            labelFor(headerCell, 20)?.text = TR("choose_language")

        }
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
            cell.layoutIfNeeded()
            
            labelFor(cell, 20)?.text = TR(setting_strings[0][indexPath.row]).capitalized  + " " + TR("drawing3")

            
            if let img = cell.contentView.viewWithTag(10) as? UIImageView{
                
                img.image = UIImage(named: lottery_images[indexPath.row])
            }
            
            if let switcher = cell.contentView.viewWithTag(30) as? MySwitch{
                switcher.subTag = indexPath
                switcher.setOn( notifications_switch[indexPath.row], animated: false)
                switcher.addTarget(self, action: #selector(onSwitcher), for: .valueChanged)
            }
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "id_language", for: indexPath)
 
            cell.layoutIfNeeded()
            
            labelFor(cell, 20)?.text = setting_strings[1][indexPath.row]
 
            cell.accessoryType = current_language_ind == indexPath.row ? .checkmark : .none
    
            return cell

        }

        
        
        
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            onLangChange(indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    func onLangChange(_ ind : Int){
                
        MemoryControll.setLanguage(ind)
        
        setTitle()
    
        sendEvent("EVENT_LANGUAGE_CHANGE", ["key" : langCodes[ind]])
        
        saveDeviceSettings()
    }
    
    @objc func onSwitcher(_ sender : MySwitch){
        
        notifications_switch[sender.subTag!.row] = !notifications_switch[sender.subTag!.row]
      
        saveDeviceSettings()
    }


}
