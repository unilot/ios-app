//
//  Details.swift
//  Unilot
//
//  Created by Alyona on 10/15/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit



class Details: ControllerCore, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableMain: UITableView!
    
    var dataForTable = [87687,87687,987987,98798,98,98988,8,98,98,9,9,9]//[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        
        navigationController?.updateFocusIfNeeded()
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
                                              width: tableView.frame.width,
                                              height: 44))
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "id_header")!
        headerView.addSubview(headerCell)
        
        labelFor(headerCell, 10)?.text = TR("МЕСТО")
        labelFor(headerCell, 20)?.text = TR("КОШЕЛЕК")
        
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
        
        cell.layoutIfNeeded()
        
//        let item = dataForTable[indexPath.row]
        
        labelFor(cell, 10)?.text = "345"
        labelFor(cell, 20)?.text = "widruy3o4b7rt283nylri348y58234tv235t"
        labelFor(cell, 30)?.text = "234,456"
        labelFor(cell, 40)?.text = "4.598"
 
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = kColorLightGray
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
        
    }
    
    
    //MARK: -  Buttons
    
    
    @IBAction func onQRCode(){
        
    }
    
    
    
    @IBAction func onBackAction(){
        navigationController?.popViewController(animated: true)
    }
}
