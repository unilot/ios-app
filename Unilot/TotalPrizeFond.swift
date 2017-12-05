//
//  TotalPrizeFond.swift
//  Unilot
//
//  Created by Alyona on 10/6/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit

class TotalPrizeFond: PopUpCore, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var titleWithPrice: UILabel!
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var trophy: SpecialItem!

    @IBOutlet weak var close: UIButton!

    @IBOutlet weak var firstLabel: UILabel!

    var dataForTable = [UserForGame]()
    var widthOfCell = CGFloat(0)

    
    var activityData = ActivityData.init(size: CGSize(width: 40, height: 40),
                                         type: .lineScalePulseOut,
                                         color: UIColor.white)

    
    
    class func createTotalPrizeFond() -> TotalPrizeFond {
        let myClassNib = UINib(nibName: "TotalPrizeFond", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! TotalPrizeFond
    }
    
    override func setInitBorders() {
 
        let ptophyUpper = setColorForImage(trophy.frame.size, "trophy-x3")
        
        trophy.addSubview(ptophyUpper)
        
        widthOfCell = frame.width * 0.9
        
        titleWithPrice.text = "\(current_game.prize_amount) ETh = $ \(current_game.prize_amount_fiat)"

        titleMain.text = TR("total_jackpot")
        close.setTitle(TR("close"), for: .normal)
        firstLabel.text = TR("prize_\nplaces")
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        NetWork.getListWinners(current_game.game_id, completion: onAnswer)
        
    }
    
    func onAnswer(_ error :String?) {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

        if error != nil {
  
            delegate?.showError(error!)
            
        } else {
            
            
            dataForTable =  winners_list.sorted(by: {  return $0.position < $1.position})

            tableMain.reloadData()

        }
        
        
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
            
            createCellBody(cell!)
            
        }
        
    
        setCellBody(cell!,dataForTable[indexPath.row])
        
        
        if indexPath.row % 2 == 0 {
            cell?.contentView.backgroundColor = UIColor.white
        } else {
            cell?.contentView.backgroundColor = kColorLightGray
        }
        return cell!
        
    }
    
    //MARK:-  UITableViewCell

    
    func createCellBody(_ cell : UITableViewCell) {
        
        var frame = cell.contentView.frame

        let little_shift = CGFloat(8)
        
        let first_field = CGFloat(60)
        let money_field = (widthOfCell - (little_shift + first_field)) / 2

        
        frame.size = CGSize(width: widthOfCell , height: frame.size.height)
        let shiftUpp = CGFloat(-8)
        let first = UILabel(frame: CGRect(x: little_shift, y: shiftUpp,
                                          width: first_field, height: frame.height))
        first.text = " "
        first.tag = 10
        first.textColor = UIColor.black
        first.numberOfLines = 2
        first.textAlignment = .center
        first.font = UIFont(name: kFont_Light, size: 12)
        cell.contentView.addSubview(first)
        
        let second = UILabel(frame: CGRect(x: little_shift + first_field,
                                           y: shiftUpp,
                                           width: money_field,
                                           height: frame.height))
        second.text = " "
        second.adjustsFontSizeToFitWidth = true
        second.tag = 20
        second.textAlignment = .center
        second.textColor = UIColor.black
        second.font = UIFont(name: kFont_Light, size: 12)
        cell.contentView.addSubview(second)

        let third = UILabel(frame: CGRect(x: little_shift + first_field + money_field,
                                          y: shiftUpp,
                                          width: money_field,
                                          height: frame.height))
        third.text = " "
        third.tag = 30
        third.textColor = UIColor.black
        third.textAlignment = .center
        third.font = UIFont(name: kFont_Light, size: 12)
        third.adjustsFontSizeToFitWidth = true
        cell.contentView.addSubview(third)
        
         
    }
    
    func setCellBody(_ cell : UITableViewCell, _ item : UserForGame) {
        
        labelFor(cell, 10)?.text = "\(item.position)"
        labelFor(cell, 20)?.text = "\(item.prize_amount)"
        labelFor(cell, 30)?.text = "\(item.prize_amount_fiat)"
        

    }

    
}
