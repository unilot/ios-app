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
    
    
    var dataForTable = [
        ["Дневной лотерее","Недельной лотерее","Бонусной лотерее"],
        ["English","Русский","中文","Español","Français","Italiano","日本語"]]
    
    var viewWithPlaces : TotalPrizeFond? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
    }
    
    
    override func setTitle() {
        navigationItem.title = TR("Настройки")
    }
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForTable[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: tableView.frame.width,
                                              height: 44))
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "id_header")!
        headerView.addSubview(headerCell)
        
        switch section {
        case 0:
            labelFor(headerCell, 20)?.text = TR("Получать уведомлять о")

        default:
            labelFor(headerCell, 20)?.text = TR("Выбор языка")

        }
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
            cell.layoutIfNeeded()
            
            labelFor(cell, 20)?.text = dataForTable[0][indexPath.row]

            
            if let img = cell.contentView.viewWithTag(10) as? UIImageView{
                
                img.image = UIImage(named: lottery_images[indexPath.row])
            }
            
            if let switcher = cell.contentView.viewWithTag(30) as? MySwitch{
                switcher.subTag = indexPath
                switcher.isOn = notifications_switch[indexPath.row]
                switcher.addTarget(self, action: #selector(SettingsView.onSwitcher(_:)), for: .valueChanged)
            }
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "id_language", for: indexPath)
 
            cell.layoutIfNeeded()
            
            labelFor(cell, 20)?.text = dataForTable[1][indexPath.row]

            if current_language == dataForTable[1][indexPath.row]{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell

        }

        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            current_language = dataForTable[1][indexPath.row]
            tableView.reloadData()
        }

    }
    
    
    func onSwitcher(_ sender : MySwitch){
        
        notifications_switch[sender.subTag!.row] = !notifications_switch[sender.subTag!.row]
        table.reloadRows(at: [sender.subTag!], with: .none)
    }
    
    
}
