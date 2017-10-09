//
//  HistoryTable.swift
//  Unilot
//
//  Created by Alyona on 10/9/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit



class HistoryTable: UITableViewController{
    
    
    var dataForTable = [87687,87687,987987,98798,98,98988,8,98,98,9,9,9]//[String]()
    var viewWithPlaces : TotalPrizeFond?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuButton()
        
        navigationItem.title = "History"
        
    }
    
    func setMenuButton(){
        
        let imageItem = setColorForImage(CGSize(width: 30, height: 30), "menu")
        let backItem = UIBarButtonItem(customView: imageItem)
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = backItem
        
        if let nav = (navigationController as? NavigationController ) {
            nav.initNavigationData(backItem)
        }
    }
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForTable.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "id_header", for: indexPath)
            
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
        
        cell.layoutIfNeeded()
        
        
        if let label = cell.contentView.viewWithTag(10) as? UILabel{
            
            label.text = "10.10.17"
        }
        
        
        if let img = cell.contentView.viewWithTag(20) as? UIImageView{
            
            img.image = UIImage(named: "`1day-x3")
        }
        

        
        
        if let label = cell.contentView.viewWithTag(30) as? UILabel{
            
            label.text = "завершена"
        }
        
        if let label = cell.contentView.viewWithTag(40) as? UILabel{
            
            label.text = "список победителей"
        }
        
        
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = kColorLightGray
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if (view.viewWithTag(1000) as? TotalPrizeFond) != nil {
            onPrizePlaces()
        }
        
    }
 
    
    
    func onPrizePlaces(){
        
        
        if viewWithPlaces ==  nil {
            viewWithPlaces = TotalPrizeFond.createTotalPrizeFond()
            viewWithPlaces!.tag = 1000
            viewWithPlaces!.layoutIfNeeded()
        }
        
        viewWithPlaces!.layer.opacity = 0.0
        viewWithPlaces!.frame = CGRect(x: 10,
                                      y: view.frame.height,
                                      width: view.frame.width - 20,
                                      height: view.frame.height - 110)
        
        viewWithPlaces!.initView()
        

        view.addSubview(viewWithPlaces!)
        
        UIView.animate(withDuration: 0.4) {
            self.viewWithPlaces!.layer.opacity = 1.0
            self.viewWithPlaces!.frame = CGRect(x: 10,
                                          y: 40,
                                          width: self.viewWithPlaces!.frame.width,
                                          height: self.viewWithPlaces!.frame.height)
        }
        
    }
}
