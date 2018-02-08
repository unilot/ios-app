//
//  ParticipantsView.swift
//  Unilot
//
//  Created by Alyona2013 on 2/3/18.
//  Copyright © 2018 Vovasoft. All rights reserved.
//



import UIKit

class ParticipantsView: PopUpCore, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
    var dgActivityIndicatorView : DGActivityIndicatorView?
    
    @IBOutlet weak var iconMain: UIImageView!

    @IBOutlet weak var searchMain: UISearchBar!

    @IBOutlet weak var titleWarningText: UILabel!

    @IBOutlet weak var titleUnderSerchBar: UILabel!
    
    @IBOutlet weak var tableMain: UITableView!
 
    @IBOutlet weak var close: UIButton! 
 
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var barCodeButton: UIButton!
  
    var origin_dataForTable  = [UserForGame]()
    var dataForTable = [UserForGame]()
    var widthOfCell = CGFloat(0)

    class func createParticipantsView() -> ParticipantsView {
        let myClassNib = UINib(nibName: "ParticipantsView", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! ParticipantsView
    }
    
    override func setInitBorders() {

        let icon_name = current_game.prize_currency + "Img"
        iconMain.image = UIImage(named : icon_name)
 
        widthOfCell = frame.width * 0.9
        
        titleMain.text = TR(tabbar_strings[getTabBarTag(current_game.type)]).capitalized + " " + TR("drawing1")
        
        titleUnderSerchBar.text = TR("list_of_participants")
        
        titleWarningText.text = TR("text_condition_\(current_game.type)")
            
        close.setTitle(TR("close"), for: .normal)

        showActivityViewIndicator()
        
        NetWork.getParticipantsList(current_game.game_id, completion: onAnswer)
        
    }
    
    func onAnswer(_ error :String?) {
        
        
        hideActivityViewIndicator()
        
        if error != nil {
            
            delegate?.showError(error!)
            
        } else {
 
            origin_dataForTable = winners_list.sorted(by: { (user1 : UserForGame, user2 : UserForGame ) -> Bool in
            
                if isMywalletHasTheNumber(user1.user_id){

                    return true
                }
                
                return false
             })

            dataForTable = origin_dataForTable
            
            tableMain.reloadData()
            tableMain.isUserInteractionEnabled = true
            tableMain.allowsSelection = true
        }
        
        
    }
    
    
    
    //MARk : - Loading
    
    func showActivityViewIndicator(){
        
        if dgActivityIndicatorView == nil {
            dgActivityIndicatorView = DGActivityIndicatorView.init(type: .cookieTerminator, tintColor: kColorHistoryGray, size: 40)
            dgActivityIndicatorView?.center = self.center
            self.addSubview(dgActivityIndicatorView!)
            
        }
        
        dgActivityIndicatorView!.startAnimating()
        
        
    }
    
    func hideActivityViewIndicator(){
        
        dgActivityIndicatorView?.stopAnimating()
        dgActivityIndicatorView?.removeFromSuperview()
        dgActivityIndicatorView = nil
        
    }
    
    
    
    //MARK:-  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForTable.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "id_cell")
        
        if (cell == nil)
        {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "id_cell")
            cell?.contentView.layer.cornerRadius = 13
            cell?.selectionStyle = .none

            createCellBody(cell!)
            
        }
        
        let item = dataForTable[indexPath.row]
        setCellBody(cell!,item)
        
        
        if indexPath.row % 2 == 0 {
            cell?.contentView.backgroundColor = UIColor.white
        } else {
            cell?.contentView.backgroundColor = kColorLightGray
        }
        
        if isMywalletHasTheNumber(item.user_id){

            cell?.contentView.backgroundColor = kColorLightYellow
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item : UserForGame = dataForTable[indexPath.row]
        
        saveToClipboard(item.user_id)
        
    }
    
    //MARK:-  UITableViewCell
    
    
    func createCellBody(_ cell : UITableViewCell) {
 
        var frame = cell.contentView.frame
        
        let little_shift = CGFloat(8)
 
        frame.size = CGSize(width: widthOfCell , height: frame.size.height)
        let shiftUpp = CGFloat(-8)
        let first = UILabel(frame: CGRect(x: little_shift, y: shiftUpp,
                                          width: frame.width - little_shift / 2, height: frame.height))
        first.text = " "
        first.tag = 10
        first.textColor = UIColor.black
        first.numberOfLines = 1
        first.textAlignment = .center
        first.font = UIFont(name: kFont_Light, size: 12)
        cell.contentView.addSubview(first)
 
    }
    
    func setCellBody(_ cell : UITableViewCell, _ item : UserForGame) {
        
        labelFor(cell, 10)?.text =  item.user_id
        
    }
    
    
    //MARK:-  OnButtons
    
    @IBAction func onQRCode(_ sender : UIButton){
        
        current_controller_core?.onQRScan(sender)
        current_controller_core?.barCodeResonder = self
    }
    
    
    @IBAction func onSearch(){
        
        revealSearchLine()
        searchMain.becomeFirstResponder()

    }
 
    
    override func onQRAnswer(_ haveText : String?){
        
        searchMain.text = haveText
        revealSearchLine()
        reloadTableWithText()
        
    }
    
    func reloadTableWithText(){
        
        dataForTable = tableSorting(searchtext:  searchMain.text, origin_dataForTable: origin_dataForTable)
        
        tableMain.reloadData()
        
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        hideSearchLine()
        return true
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        revealSearchLine()
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        reloadTableWithText()
        
    }
    
    //MARK: - SearchLine

    func revealSearchLine(){
        
        searchMain.layer.opacity = 1.0
        titleUnderSerchBar.layer.opacity = 0.0
        searchButton.layer.opacity = 0.0
        
    }
    
    func hideSearchLine(){
        searchMain.layer.opacity = 0.0
        titleUnderSerchBar.layer.opacity = 1.0
        searchButton.layer.opacity = 1.0
    }
    
}

