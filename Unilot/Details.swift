//
//  Details.swift
//  Unilot
//
//  Created by Alyona on 10/15/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit



class Details: ControllerCore, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var searchMain: UISearchBar!
    
 
    var origin_dataForTable  = [[String: String]]()
    var dataForTable  = [[String: String]]()
    
    var from_date = "31.08.17"
    var from_lottery = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavControllerClear()
    
        setTitle()
        
        tableMain.layer.opacity = 0.0

        NetWork.getLotteryDetails(onAnswerSuccess, onAnswerError)
        
    }

    
    
    override func setTitle(){
        
        let height = navigationController!.navigationBar.frame.height
        let width =  CGFloat(300)//navigationController!.navigationBar.frame.width
        
        let title_view = UIView(frame : CGRect(x: 0,
                                               y: 0,
                                               width:  width,
                                               height: height))
        

        let image_view = UIImageView(frame: CGRect(x: 0, y:  height/4,
                                              width:  height/2,
                                              height: height/2))
        
        image_view.image = UIImage(named: lottery_images[from_lottery])
        image_view.contentMode = .scaleAspectFit
        image_view.clipsToBounds = true
        
        
        let title = UILabel(frame: CGRect(x: height , y: 0,
                                          width: width - height/2,
                                          height: height))
        
        // create attributed string

        
        let attr1 = [ NSFontAttributeName: UIFont(name: kFont_Regular, size: 15.0)!,
                            NSForegroundColorAttributeName : UIColor.white]

        let first_string = NSMutableAttributedString(string:TR("Розыгрыш от") + ": ", attributes: attr1 )
        
        let attr2 = [ NSFontAttributeName: UIFont(name: kFont_Regular, size: 15.0)!,
                            NSForegroundColorAttributeName : kColorMenuPeach]
        
        let second_string = NSMutableAttributedString(string:from_date, attributes: attr2 )


        first_string.append(second_string)
       
        title.attributedText = first_string
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        
        
        title_view.addSubview(image_view)
        title_view.addSubview(title)
        
//        title_view.center = CGPoint(x: navigationController!.navigationBar.width / 2.0,
//                                    y: navigationController!.navigationBar.height / 2.0)

        navigationItem.titleView = title_view
        
    }
    
    //MARK: -  NetWork

    override func onAnswerSuccess(_ dataRecieved : [[String: String]]){
        
        dataForTable = dataRecieved
        origin_dataForTable = dataRecieved
        
        tableMain.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            
            self.tableMain.layer.opacity = 1.0
            
        }
    }
    
    
    
    //MARK: -  UITableViewDelegate, UITableViewDataSource
    
    
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
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()

        
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: tableView.frame.width,
                                              height: 44))
      
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "id_header")!
       
        headerCell.setNeedsLayout()
        headerCell.layoutIfNeeded()
       
        headerView.addSubview(headerCell)

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        
        labelFor(headerCell, 10)?.text = TR("МЕСТО")
        labelFor(headerCell, 20)?.text = TR("КОШЕЛЕК")
        
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
        
        cell.layoutIfNeeded()
        
//        let item = dataForTable[indexPath.row]
    
        
        let item = dataForTable[indexPath.row]

        
        labelFor(cell, 10)?.text = item["place"]
        labelFor(cell, 20)?.text = item["key"]
        labelFor(cell, 30)?.text = item["eth"]
        labelFor(cell, 40)?.text = item["usd"]
        

 
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = kColorLightGray
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        
        if users_account_number.contains( item["key"]!) {
            cell.contentView.backgroundColor = kColorLightYellow
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        saveToClipboard(dataForTable[indexPath.row]["key"]!)
        
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        reloadTableWithText()

    }
    
    //MARK: -  Buttons
    
    
    override func onQRAnswer(_ haveText : String?){
        searchMain.text = haveText
        reloadTableWithText()
        
    }

    func reloadTableWithText(){
        
        let searchtext = searchMain.text
        
        if searchtext != nil && searchtext!.characters.count > 0{
            
            dataForTable = origin_dataForTable.filter({ (item : [String : String]) -> Bool in
              
                return item["key"]?.contains(searchtext!) ?? false
                
            })
            
        } else {
           
            dataForTable = origin_dataForTable
            
        }
        
        tableMain.reloadData()

    }
    
    @IBAction func onBackAction(){
        navigationController?.popViewController(animated: true)
    }
}
