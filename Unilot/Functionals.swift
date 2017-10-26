//
//  Functionals.swift
//  Unilot
//
//  Created by Alyona on 10/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import SCLAlertView
import QRCodeReader




struct GameInfo {
    
    var id                  : Int
    var smart_contract_id   : String
    var num_players         : Int
    var prize_amount        : Float
    var prize_amount_fiat   : Float
    var started_at          : Date
    var ending_at           : Date
    var status              : Int
    var type                : Int
    
    
    static func empty() -> GameInfo{
        return GameInfo(id: 0,
                              smart_contract_id: kEmpty,
                              num_players: 0,
                              prize_amount: 0,
                              prize_amount_fiat: 0,
                              started_at: Date(),
                              ending_at: Date(),
                              status: 0,
                              type: 0)
    }
    
    static func fill(_ data :[String : Any]) -> GameInfo{
 
        var item =  GameInfo.empty()
        
        item.id                 = data["id"] as! Int,
        item.smart_contract_id  = data["smart_contract_id"] as! String,
        item.num_players        = data["num_players"] as! Int,
        item.prize_amount       = data["prize_amount"] as! Float,
        item.prize_amount_fiat  = data["prize_amount_fiat"] as! Float,
        item.started_at         = Date(),
        item.ending_at          = Date(),
        item.status             = data["status"] as! Int,
        item.type               = data["type"] as! Int
        
        
        
        guard let data = try?  GameInfo(id: data["id"] as! Int,
                                        smart_contract_id: data["smart_contract_id"] as! String,
                                        num_players: data["num_players"] as! Int,
                                        prize_amount: data["prize_amount"] as! Float,
                                        prize_amount_fiat: data["prize_amount_fiat"] as! Float,
                                        started_at: Date(),
                                        ending_at: Date(),
                                        status: data["status"] as! Int,
                                        type: data["type"] as! Int) else {
                                            
            print("There was an error!")
                                            return item
        }
        
        return item
    
    }
    
    
}




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

