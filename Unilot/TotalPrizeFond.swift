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
    
    var dataForTable = [87687,87687,987987,98798,98,98988,8,98,98,9,9,9]//[String]()
    
    
    
    class func createTotalPrizeFond() -> TotalPrizeFond {
        let myClassNib = UINib(nibName: "TotalPrizeFond", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! TotalPrizeFond
    }
    
    override func setInitBorders() {
        let ptophyUpper = setColorForImage(trophy.frame.size, "trophy-x3")
        trophy.addSubview(ptophyUpper)
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
            
            cell?.setNeedsLayout()
            cell?.layoutIfNeeded()
            
            cell?.contentView.layer.cornerRadius = 13

            createCellBody(cell!)
            
        }
        
        
        
        setCellBody(cell!,["3-567","67.463.536","345.544"])
        
        
        if indexPath.row % 2 == 0 {
            cell?.contentView.backgroundColor = UIColor.white
        } else {
            cell?.contentView.backgroundColor = kColorLightGray
        }
        return cell!
        
    }
    
    //MARK:-  UITableViewCell

    
    func createCellBody(_ cell : UITableViewCell) {
        
        let frame = cell.contentView.frame

        let shiftUpp = CGFloat(-8)
        let first = UILabel(frame: CGRect(x: 6, y: shiftUpp,
                                          width: frame.width/3, height: frame.height))
        first.text = " "
        first.tag = 10
        first.textColor = UIColor.black
        first.font = UIFont(name: kFont_Light, size: 12)
        first.adjustsFontSizeToFitWidth = true
        cell.contentView.addSubview(first)
        
        let second = UILabel(frame: CGRect(x: frame.width/3, y: shiftUpp,
                                           width: frame.width/3, height: frame.height))
        second.text = " "
        second.adjustsFontSizeToFitWidth = true
        second.tag = 20
        second.textAlignment = .center
        second.textColor = UIColor.black
        second.font = UIFont(name: kFont_Light, size: 12)
        cell.contentView.addSubview(second)

        let third = UILabel(frame: CGRect(x: frame.width/3 * 2, y: shiftUpp,
                                          width: frame.width/3, height: frame.height))
        third.text = " "
        third.tag = 30
        third.textColor = UIColor.black
        third.textAlignment = .center
        third.font = UIFont(name: kFont_Light, size: 12)
        third.adjustsFontSizeToFitWidth = true
        cell.contentView.addSubview(third)
        
    }
    
    func setCellBody(_ cell : UITableViewCell, _ withData : [String] ) {
      
        
        if let item = cell.contentView.viewWithTag(10) as? UILabel {
            item.text = withData[0]
        }
        
        if let item = cell.contentView.viewWithTag(20) as? UILabel {
            item.text = withData[1]
        }

        if let item = cell.contentView.viewWithTag(30) as? UILabel {
            item.text = withData[2]
        }

    }
    

}
