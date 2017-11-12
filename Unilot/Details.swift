//
//  Details.swift
//  Unilot
//
//  Created by Alyona on 10/15/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import Foundation
import SCLAlertView


class Details: ControllerCore, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var searchMain: UISearchBar!
  
    
    @IBOutlet weak var t_jackpot: UILabel!
    @IBOutlet weak var t_users: UILabel!
    @IBOutlet weak var t_winners: UILabel!

    @IBOutlet weak var eth: UILabel!
    @IBOutlet weak var users: UILabel!
    @IBOutlet weak var winners: UILabel!
    
    
    var origin_dataForTable  = [UserForGame]()
    var dataForTable  = [UserForGame]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setNavControllerClear()
    
        setTitle()
        
        tableMain.layer.opacity = 0.0
        
        
        addTouchForKeyBoard()
        
        showActivityViewIndicator()
                
        NetWork.getListWinners(local_current_game.game_id,completion: onAnswer)
        
    }
    
    func onAnswer(_ error : String?){
 
        hideActivityViewIndicator()
        
        if error != nil{
            
            SCLAlertView().showError(" ", subTitle: error!)
 
        } else {
            
            dataForTable =  winners_list.sorted(by: {  return $0.position < $1.position})
            
            origin_dataForTable = dataForTable
        
            winners.text = "\(dataForTable.count)"
        
        }
        
        tableMain.reloadData()
        
        setTableHeader()

        UIView.animate(withDuration: 0.5) {
            
            self.tableMain.layer.opacity = 1.0
            
        }
    }
    
    override func setTitle(){
        
        t_jackpot.text = TR("jackpot").uppercased()
        t_users.text = TR("participants").uppercased()
        t_winners.text = TR("winners").uppercased()
        
        
        // fill data in title
        
        let date_string = getNiceDateFormatShortString(from: local_current_game.started_at)
        let game_image = kTypeImage[local_current_game.type]!
        
        eth.text = "\(local_current_game.prize_amount)"
        users.text = "\(local_current_game.num_players)"
        
        let height = navigationController!.navigationBar.frame.height
        let width =  CGFloat(300)//navigationController!.navigationBar.frame.width
        
        
        // title image
        
        let title_view = UIView(frame : CGRect(x: 0,
                                               y: 0,
                                               width:  width,
                                               height: height))
        

        let image_view = UIImageView(frame: CGRect(x: 0, y:  height/4,
                                              width:  height/2,
                                              height: height/2))
        
        image_view.image = UIImage(named: game_image)
        image_view.contentMode = .scaleAspectFit
        image_view.clipsToBounds = true
        
        
        let title = UILabel(frame: CGRect(x: height * 0.75 , y: 0,
                                          width: width - height/2,
                                          height: height))
        
        
        // create attributed string

        
        let attr1 = [ NSFontAttributeName: UIFont(name: kFont_Regular, size: 14.0)!,
                            NSForegroundColorAttributeName : UIColor.white]

        let first_string = NSMutableAttributedString(string:TR("drawing_dated") + ": ", attributes: attr1 )
        
        let attr2 = [ NSFontAttributeName: UIFont(name: kFont_Regular, size: 16.0)!,
                            NSForegroundColorAttributeName : kColorMenuPeach]
        
        let second_string = NSMutableAttributedString(string: date_string,
                                                      attributes: attr2 )
 
        first_string.append(second_string)
       
        title.attributedText = first_string
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        
        title_view.addSubview(image_view)
        title_view.addSubview(title)
        
        
        navigationItem.titleView = title_view
        
    }
    
    
    
    //MARK: -  UITableViewDelegate, UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForTable.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    
    
    func setTableHeader(){
        
        let header_view = tableMain.tableHeaderView!
        
        if let label = header_view.viewWithTag(10) as? UILabel{
            label.text = TR("place").uppercased()
        }
        
        if let label = header_view.viewWithTag(20) as? UILabel{
            label.text = TR("wallet").uppercased()
        }

    }
 
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell", for: indexPath)
        
        cell.layoutIfNeeded()

        
        let item : UserForGame = dataForTable.first {   $0.position == indexPath.row + 1 }!
 
        labelFor(cell, 10)?.text = "\(item.position)"
        labelFor(cell, 20)?.text = item.user_id
        labelFor(cell, 30)?.text = "\(item.prize_amount)"
        labelFor(cell, 40)?.text = "\(item.prize_amount_fiat)"
        
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = kColorLightGray
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        
        if users_account_number.contains( item.user_id) {
            cell.contentView.backgroundColor = kColorLightYellow
        }
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item : UserForGame = dataForTable.first {   $0.position == indexPath.row + 1 }!

        saveToClipboard(item.user_id)
        
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

    
    func containsText(_ item : UserForGame, _ searchtext : String) -> Bool {
     
        let search_text = searchtext.lowercased()

        let text1 = item.user_id.lowercased()
        let text2 = "\(item.position)"
        let text3 = "\(item.prize_amount)"
        let text4 = "\(item.prize_amount_fiat)"
        
        return  text1.contains(search_text) || text2.contains(search_text) ||
                text3.contains(search_text) || text4.contains(search_text)
        
    }
    
    func reloadTableWithText(){
        
        let searchtext = searchMain.text
        
        if searchtext != nil && searchtext!.characters.count > 0{
            
            dataForTable = origin_dataForTable.filter({ (item : UserForGame) -> Bool in
              
                return containsText(item, searchtext!)
                
            })
            
        } else {
           
            dataForTable = origin_dataForTable
            
        }
        
        tableMain.reloadData()

    }
    
    @IBAction func onBackAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
    override  func answerFromKeyBoardClosed(){
     
        searchMain.resignFirstResponder()
        
    }
    
}
