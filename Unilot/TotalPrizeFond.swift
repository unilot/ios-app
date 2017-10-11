//
//  TotalPrizeFond.swift
//  Unilot
//
//  Created by Alyona on 10/6/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//


import UIKit



class TotalPrizeFond: UIView, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var titleMain: UILabel!
    @IBOutlet weak var titleWithPrice: UILabel!
    @IBOutlet weak var tableMain: UITableView!
    
    var dataForTable = [87687,87687,987987,98798,98,98988,8,98,98,9,9,9]//[String]()
    
    
    
    class func createTotalPrizeFond() -> TotalPrizeFond {
        let myClassNib = UINib(nibName: "TotalPrizeFond", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! TotalPrizeFond
    }
    
    
    
    
    func initView(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = kColorLightGray.cgColor

    }
    
    
    @IBAction func onX(){
        UIView.animate(withDuration: 0.4, animations: {
            self.frame = CGRect(x: 10,
                                y: -self.frame.height,
                                width: self.frame.width,
                                height: self.frame.height)
            self.layer.opacity = 0.0
        }) { (animate : Bool) in
            self.removeFromSuperview()
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
            
            cell?.updateConstraints()
            
            cell?.contentView.layer.cornerRadius = 8
            cell?.contentView.layoutIfNeeded()
            createCellBody(cell!)
            
        }
        
        
        
        setCellBody(cell!,["3-567","67.463.536","345.544"])
        
        
        if indexPath.row % 2 == 0 {
            cell?.contentView.backgroundColor = kColorLightGray
        } else {
            cell?.contentView.backgroundColor = UIColor.white
        }
        return cell!
        
    }
    
    //MARK:-  UITableViewCell

    
    func createCellBody(_ cell : UITableViewCell) {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let frame = cell.contentView.frame

        let shiftUpp = CGFloat(-8)
        let first = UILabel(frame: CGRect(x: 6, y: shiftUpp,
                                          width: frame.width/3, height: frame.height))
        first.text = " "
        first.tag = 10
        first.font = UIFont(name: "Helvetica", size: 12)
        first.adjustsFontSizeToFitWidth = true
        cell.contentView.addSubview(first)
        
        let second = UILabel(frame: CGRect(x: frame.width/3, y: shiftUpp,
                                           width: frame.width/3, height: frame.height))
        second.text = " "
        second.adjustsFontSizeToFitWidth = true
        second.tag = 20
        second.textAlignment = .center
        second.font = UIFont(name: "Helvetica", size: 12)
        cell.contentView.addSubview(second)

        let third = UILabel(frame: CGRect(x: frame.width/3 * 2, y: shiftUpp,
                                          width: frame.width/3, height: frame.height))
        third.text = " "
        third.tag = 30
        third.textAlignment = .center
        third.font = UIFont(name: "Helvetica", size: 12)
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
