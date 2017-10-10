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

    
    var dataForTable = [87687,87687,987987,9,87,98,09,98,98,9,8,8,8,98,98,9,9,9]//[String]()
    var viewWithPlaces : TotalPrizeFond? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
 
    
    override func setTitle() {
        navigationItem.title = "History"
    }
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForTable.count
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
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
       
        labelFor(headerCell, 10)?.text = TR("Дата")
        labelFor(headerCell, 30)?.text = TR("Лотерея")
        labelFor(headerCell, 30)?.text = TR("Статус")
        labelFor(headerCell, 40)?.text = TR("Выйгрыш")

        return headerView
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
        
        cell.layoutIfNeeded()
        
        labelFor(cell, 10)?.text = "10.10.17"
        labelFor(cell, 30)?.text = "завершена"
        labelFor(cell, 40)?.text = "список победителей"

        if let img = cell.contentView.viewWithTag(20) as? UIImageView{
            
            img.image = UIImage(named: "`1day-x3")
        }
        
        
        if let fon = cell.contentView.viewWithTag(5) as? UIImageView{
            if indexPath.row % 2 == 0 {
                fon.backgroundColor = kColorLightGray
            } else {
                fon.backgroundColor = UIColor.white
            }

        }
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        if (view.viewWithTag(1000) as? TotalPrizeFond) != nil {
            onPrizePlaces()
 //        }
        
    }
 
    
    
    func onPrizePlaces(){
        
        
//        if viewWithPlaces ==  nil {
            viewWithPlaces = TotalPrizeFond.createTotalPrizeFond()
            viewWithPlaces!.tag = 1000
            viewWithPlaces!.layoutIfNeeded()
//        }
        
        viewWithPlaces!.layer.opacity = 0.0
        viewWithPlaces?.layer.borderWidth = 2
        viewWithPlaces!.frame = CGRect(x: 10,
                                      y: view.frame.height,
                                      width: view.frame.width - 20,
                                      height: view.frame.height - 100)
        
        viewWithPlaces!.initView()
        

        view.addSubview(viewWithPlaces!)
        
        UIView.animate(withDuration: 0.4) {
            self.viewWithPlaces!.layer.opacity = 1.0
            self.viewWithPlaces!.frame = CGRect(x: 10,
                                          y: 70,
                                          width: self.viewWithPlaces!.frame.width,
                                          height: self.viewWithPlaces!.frame.height)
        }
        
    }
    
    func labelFor(_ cell: UITableViewCell, _ index: Int) -> UILabel?{
        
        if let label = cell.contentView.viewWithTag(index) as? UILabel{
            return label
        }
        return nil
    }
}
