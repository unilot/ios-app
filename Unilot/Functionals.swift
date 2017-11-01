//
//  Functionals.swift
//  Unilot
//
//  Created by Alyona on 10/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import AVFoundation
import SCLAlertView
import QRCodeReader
import SwiftySound

//MARK: - Local Vars

var startWas : Bool = false

var local_current_game = GameInfo()
var local_current_user = UserForGame()

//MARK: - Structures

let cReviews    = 6


class UserForGame{
    
    var user_id             : String = kEmpty
    var position            : Int = 0
    var prize_amount        : Float = 0
    var prize_amount_fiat   : Float = 0
     
}


class GameInfo {
    
    var game_id             : String = kEmpty
    var smart_contract_id   : String = kEmpty
    var num_players         : Int = 0
    var prize_amount        : Float = 0
    var prize_amount_fiat   : Float = 0
    var prize_amount_local  : Int = 0
    var started_at          : Int = 0
    var ending_at           : Int = 0
    var status              : Int = kStatusNoGame
    var type                : Int = kTypeUndefined
  
}



//MARK: - Functions




func saveToClipboard(_ text : String){
    UIPasteboard.general.string = text
    let alert_text = TR("Номер") + "\n\n" + text + "\n\n" + TR("был сохранен в буфер")
    SCLAlertView().showInfo(" ", subTitle: alert_text)
}


func TR(_ str: String?) -> String{
     
    if str == nil {
        return kEmpty
    }
    return NSLocalizedString(str!,  comment: " ")
    
}


//MARK: - Games details

func getTabBarTag() -> Int{
    
    return kTypeTabBarOrder.index(of:local_current_game.type)!

}

func recountTimersForLastCounter(_ game : GameInfo) -> (Int, Int) { //now/all/stepType

    let timerNow = game.ending_at +  kTimeForPreperationWait - Int(Date().timeIntervalSince1970)
    let timeAll = kTimeForPreperationWait
    
    if timerNow > 0 {
        return (timerNow,timeAll)
    } else {
        return (0,-1)
    }
    
}

func recountTimersData(_ game : GameInfo) -> (Int, Int, Int) { //now/all/stepType
    
    let timerNow = game.ending_at - Int(Date().timeIntervalSince1970)
    let timeAll = game.ending_at - game.started_at
    
    let diff = timeAll - timerNow
    
    let typeOfStep =  ( diff > (3600 * 24) ) ? ( diff > (3600 * 24 * 30 ) ? 2 : 1) : 0
    
    if timerNow > 0 {
        return (timerNow,timeAll,typeOfStep)
    } else {
        return (0,0,-1)
    }
}


func getTextFromFileInfo() -> String? {
    let myFileUrl = Bundle.main.url(forResource: TR("HDIW"), withExtension: "txt")
    let text = try! String(contentsOf: myFileUrl!, encoding: String.Encoding.utf8)
    
    return text
}


func getNiceDateFormatString(from timeSec : Int) -> String {

    let currentDate = Date(timeIntervalSince1970: TimeInterval(timeSec))
    let  calendar = NSCalendar.current
    let components = calendar.dateComponents([.year,.month,.day], from: currentDate)
    
    return "\(components.year!).\(components.month!).\(components.day!)"
}


func getNiceFullDateFormatString(from timeSec : Int) -> String {
    
    let currentDate = Date(timeIntervalSince1970: TimeInterval(timeSec))
    let  calendar = NSCalendar.current
    let components = calendar.dateComponents([.year,.month,.day], from: currentDate)
    
    return "\(components.year!).\(components.month!).\(components.day!)"
}



func labelFor(_ cell: UITableViewCell, _ index: Int) -> UILabel?{
    
    if let label = cell.contentView.viewWithTag(index) as? UILabel{
        return label
    }
    return nil
}

func create_fon_view(_ size: CGSize) -> UIImageView {

    let amount = CGFloat(100)

    let bg_view = UIImageView(frame : CGRect(x: -amount, y: 0,
                                             width: size.width + 2*amount,
                                             height:  size.height))
    
    bg_view.image =  UIImage(named: "bg_1")
    bg_view.contentMode = .scaleAspectFill
    addParallaxToView(bg_view, Int(amount))
    
    return bg_view
}



func addParallaxToView(_ forView: UIView, _ bounce : Int) {
    
    let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
    horizontal.minimumRelativeValue = -bounce
    horizontal.maximumRelativeValue = bounce
    
//    let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
//    vertical.minimumRelativeValue = -bounce
//    vertical.maximumRelativeValue = bounce
    
    let group = UIMotionEffectGroup()
    group.motionEffects = [horizontal]
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


func openUrlFromApp(_ path : String ){
    
    let url = URL(string: path)
    
    if url == nil {
        return
    }
    
    if UIApplication.shared.canOpenURL(url!) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
            
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
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


func playStandart(){
    
    Sound.play(file: "win.mp3")

    // create a sound ID, in this case its the tweet sound.
//    let systemSoundID: SystemSoundID = 1016
    
    // to play sound
//    AudioServicesPlaySystemSound (systemSoundID)
    
}

func playWin() {
     
    Sound.play(file: "win.mp3")
    
//    let audioFilePath = Bundle.main.path(forResource: "win", ofType: "mp3")
//    
//    if audioFilePath != nil {
//        
//        let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
//        
//        
//        do {
//            let sound = try AVAudioPlayer(contentsOf: audioFileUrl)
//            sound.numberOfLoops = 1
//            sound.prepareToPlay()
//            sound.play()
//            
////            let audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
////            audioPlayer.prepareToPlay()
////            audioPlayer.play()
//
//            // use audioPlayer
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            // error is now an NSError instance; do what you will
//        }
//        
//        
//        
//    }
}

