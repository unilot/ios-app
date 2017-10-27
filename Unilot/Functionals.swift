//
//  Functionals.swift
//  Unilot
//
//  Created by Alyona on 10/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import SCLAlertView
import QRCodeReader





//MARK: - Local Vars

var local_current_game_type = kTypeDay



//MARK: - Structures

let cReviews    = 6



class GameInfo : NSObject, NSCoding{
    
    
    var game_id             : Int = 0
    var smart_contract_id   : String = kEmpty
    var num_players         : Int = 0
    var prize_amount        : Float = 0
    var prize_amount_fiat   : Float = 0
    var prize_amount_local  : Float = 0
    var started_at          : Int = 0
    var ending_at           : Int = 0
    var status              : Int = 0
    var type                : Int = 0
    
 
 
    func encode(with aCoder: NSCoder){
        
        aCoder.encode(self.game_id, forKey: "game_id")
        aCoder.encode(self.smart_contract_id, forKey: "smart_contract_id")
        aCoder.encode(self.num_players, forKey: "num_players")
        aCoder.encode(self.prize_amount, forKey: "prize_amount")
        aCoder.encode(self.prize_amount_fiat, forKey: "prize_amount_fiat")
        aCoder.encode(self.prize_amount_local, forKey: "prize_amount_local")
        aCoder.encode(self.started_at, forKey: "started_at")
        aCoder.encode(self.ending_at, forKey: "ending_at")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.type, forKey: "type")
        
    }
    
    
    required init (coder aDecoder: NSCoder) {
        self.game_id = aDecoder.decodeObject(forKey: "game_id") as! Int
        self.smart_contract_id = aDecoder.decodeObject(forKey: "smart_contract_id") as! String
        self.num_players = aDecoder.decodeObject(forKey: "num_players") as! Int
        self.prize_amount = aDecoder.decodeObject(forKey: "prize_amount") as! Float
        self.prize_amount_fiat = aDecoder.decodeObject(forKey: "prize_amount_fiat") as! Float
        self.prize_amount_local = aDecoder.decodeObject(forKey: "prize_amount_local") as! Float
        self.started_at = aDecoder.decodeObject(forKey: "started_at") as! Int
        self.ending_at = aDecoder.decodeObject(forKey: "ending_at") as! Int
        self.status = aDecoder.decodeObject(forKey: "status") as! Int
        self.type = aDecoder.decodeObject(forKey: "type") as! Int
    }
    
    
    override init() {
        super.init()
    }
}



//MARK: - Functions

func saveToClipboard(_ text : String){
    UIPasteboard.general.string = text
    SCLAlertView().showInfo(" ", subTitle: "The number\n\n\(text)\n\nwas saved to clipboard")
}


func TR(_ str: String?) -> String{
    
    
    if str == nil {
        return kEmpty
    }
    return NSLocalizedString(str!,  comment: " ")
    
}


func labelFor(_ cell: UITableViewCell, _ index: Int) -> UILabel?{
    
    if let label = cell.contentView.viewWithTag(index) as? UILabel{
        return label
    }
    return nil
}

func create_fon_view(_ size: CGSize) -> UIImageView {

    let amount = CGFloat(10)

    let bg_view = UIImageView(frame : CGRect(x: -amount, y: -amount,
                                             width: size.width + 2*amount,
                                             height:  size.height + 2*amount))
    
    bg_view.image =  UIImage(named: "bg_1")
    bg_view.contentMode = .scaleToFill
    addParallaxToView(bg_view, Int(amount))
    
    return bg_view
}



func addParallaxToView(_ forView: UIView, _ bounce : Int) {
    
    let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
    horizontal.minimumRelativeValue = -bounce
    horizontal.maximumRelativeValue = bounce
    
    let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
    vertical.minimumRelativeValue = -bounce
    vertical.maximumRelativeValue = bounce
    
    let group = UIMotionEffectGroup()
    group.motionEffects = [horizontal, vertical]
    forView.addMotionEffect(group)
}

    

func setColorForLabel(_ sizeOfView : CGSize, _ text : String) -> UIView{
    
    let bgView = UIView(frame: CGRect(x: 0, y: 0, width:  sizeOfView.width,
                                      height: sizeOfView.height))
    bgView.backgroundColor = UIColor.clear
    
    let textLayer = CATextLayer()
    textLayer.frame = bgView.frame
    textLayer.string = text
    textLayer.fontSize = 28
    textLayer.alignmentMode = kCAAlignmentCenter
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bgView.frame
    gradientLayer.colors = [
        kColorLightYellow.cgColor,
        kColorLightOrange.cgColor
    ]
    
    //Here you can adjust the filling
    gradientLayer.locations = [0.5, 1.0]
    
    gradientLayer.mask = textLayer
    bgView.layer.addSublayer(gradientLayer)
    
    return bgView
}

func convertDate(from isoDate : String) -> Int {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = dateFormatter.date(from:isoDate)!
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
    let finalDate: Date = calendar.date(from:components) ?? Date()
    
    
    
    return Int(finalDate.timeIntervalSince1970)
    
}
func imageScaledToSize(size: CGSize, image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    image.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
    let imageR = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return imageR!;
}




func setImageForTitle(_ sizeOfView : CGSize, _ imageName : String) -> UIView{
    
    let bgView = UIImageView(frame: CGRect(x: 0, y: 0, width:  sizeOfView.width,
                                           height: sizeOfView.height))
    bgView.backgroundColor = UIColor.clear
    
    bgView.image = UIImage(named: imageName)
    
    return bgView
}

func setColorForImage(_ sizeOfView : CGSize, _ imageName : String) -> SpecialItem{
    
    let bgView = SpecialItem(frame: CGRect(x: 0, y: 0, width:  sizeOfView.width,
                                      height: sizeOfView.height))
    bgView.backgroundColor = UIColor.clear
    
    let myImage = UIImage(named: imageName)?.cgImage
    
    let myLayer = CALayer()
    myLayer.frame = bgView.frame
    myLayer.contents = myImage
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bgView.frame
    gradientLayer.colors = [
        kColorLightYellow.cgColor,
        kColorLightOrange.cgColor
    ]
    
    
    //Here you can adjust the filling
    gradientLayer.locations = [0.5, 1.0]
    
    gradientLayer.mask = myLayer
    bgView.layer.addSublayer(gradientLayer)
    
    bgView.bringSubview(toFront: bgView.numberInCircle)
    
    return bgView
}

