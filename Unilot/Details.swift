//
//  Details.swift
//  Unilot
//
//  Created by Alyona on 10/15/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit
import Foundation

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
    
    var current_game = local_current_game
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setNavControllerClear()
    
        UIApplication.shared.statusBarStyle = .lightContent

        setTitle()
        
        tableMain.layer.opacity = 0.0
        
        addTouchForKeyBoard()
        
        showActivityViewIndicator()
 
        NetWork.getListWinners(current_game.game_id,completion: onAnswer)
    }
    
    
    func onAnswer(_ error : String?){
 
        hideActivityViewIndicator()
        
        if error != nil{
            
            showError(error!)

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
        
        searchMain.placeholder = TR("your_wallet_address")
        
        // fill data in title
        
        let date_string = getNiceDateFormatShortString(from: current_game.started_at) + " - " + getNiceDateFormatShortString(from: current_game.ending_at)
        let game_image = kTypeImage[current_game.type]!
        
        eth.text = "\(current_game.prize_amount)"
        users.text = "\(current_game.num_players)"
        
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

        
        let attr1 = [ NSAttributedStringKey.font: UIFont(name: kFont_Regular, size: 14.0)!,
                            NSAttributedStringKey.foregroundColor : UIColor.white]

        let first_string = NSMutableAttributedString(string:TR("drawing_dated") + ": ", attributes: attr1 )
        
        let attr2 = [ NSAttributedStringKey.font: UIFont(name: kFont_Regular, size: 16.0)!,
                            NSAttributedStringKey.foregroundColor : kColorMenuPeach]
        
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
        return 40
    }
    
    
    func setTableHeader(){
        
        let header_view = tableMain.tableHeaderView!
        
        if let label = header_view.viewWithTag(10) as? UILabel{
            label.text = TR("place").uppercased()
        }
        
        if let label = header_view.viewWithTag(20) as? UILabel{
            label.text = TR("wallet").uppercased()
        }

        if let label = header_view.viewWithTag(30) as? UILabel{
            label.text = current_game.prize_currency.uppercased()
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
        
        
        if isMywalletHasTheNumber(item.user_id){
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

    
    func reloadTableWithText(){
        
        dataForTable = tableSorting(searchtext:  searchMain.text, origin_dataForTable: origin_dataForTable)
 
        tableMain.reloadData()

    }
    
    @IBAction func onBackAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
    override  func answerFromKeyBoardClosed(){
     
        searchMain.resignFirstResponder()
        
    }
    
    
}
