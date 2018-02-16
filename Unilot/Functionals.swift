//
//  Functionals.swift
//  Unilot
//
//  Created by Alyona on 10/10/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import AVFoundation
import SwiftySound
//import Firebase
import Fabric
import Crashlytics
import CoreImage


class Barcode {
    
    static func fromString(string : String, forWidth : CGFloat) -> UIImage? {
        
        let data = string.data(using: .isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")
        let qrImage : CIImage = filter.outputImage!

        //qrImageView is a IBOutlet of UIImageView
        let scale = forWidth / qrImage.extent.size.width
        
        let resultQrImage = qrImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        return UIImage(ciImage: resultQrImage)

    }
    
}




//MARK: - Local Vars

var startWas : Bool = false

var local_current_game = GameInfo()
var local_current_user = UserForGame()
 
//MARK: - Tech settings

var default_gas_limit = 210000
var default_gas_price = 30

//MARK: - Structures

let cReviews    = 6

let KBetDefault = Float(0.01)


class Wallet : NSObject, NSCoding{
    
    var smart_contract_id   : String = kEmpty
    var active_games        : [String] = []
  
    
    
    func encode(with aCoder: NSCoder){
        
        aCoder.encode(self.smart_contract_id, forKey: "smart_contract_id")
        aCoder.encode(self.active_games, forKey: "active_games")
        
    }
    
    
    required init (coder aDecoder: NSCoder) {
        self.smart_contract_id = aDecoder.decodeObject(forKey: "smart_contract_id") as! String
        self.active_games = aDecoder.decodeObject(forKey: "active_games") as! [String]
    }
    
    
    override init() {
        super.init()
    }
}




class UserForGame{
    
    var user_id             : String = kEmpty
    var position            : Int = -1
    var prize_amount        : Float = 0
    var prize_amount_fiat   : Float = 0
    var prize_currency      : String = kEmpty
}

class GameInfo {
    
    var game_id             : String = kEmpty
    var smart_contract_id   : String = kEmpty
    var num_players         : Int = 0
    var prize_amount        : Float = 0
    var prize_currency      : String = kEmpty
    var prize_amount_fiat   : Float = 0
    var bet_amount          : Float = KBetDefault
    var started_at          : Int = 0
    var ending_at           : Int = 0
    var status              : Int = kStatusNoGame
    var type                : Int = kTypeUndefined
    var gas_limit           : Int = 0
    var gas_price           : Int = 0

    
    func isEqual(to game: GameInfo) -> Bool{
        return  (
           game_id == game.game_id
        && smart_contract_id == game.smart_contract_id
        && num_players == game.num_players
        && prize_currency == game.prize_currency
        && prize_amount == game.prize_amount
        && prize_amount_fiat == game.prize_amount_fiat
        && bet_amount == game.bet_amount
        && started_at == game.started_at
        && ending_at == game.ending_at
        && status == game.status
        && type == game.type
        && gas_limit == game.gas_limit
        && gas_price == game.gas_price)
        
    }
}


class NotifStruct {
    
    var notif_id            : String = kEmpty
    var action              : String = kActionUndefined
    var messages            : [String: String] = [:]
    var game                : GameInfo = GameInfo()
    var data                : [String:Any]? = nil
    
}


//MARK: - Functions




func saveToClipboard(_ text : String){
    UIPasteboard.general.string = text
    let alert_text = TR("address") + ": " + text + " " + TR("was-saved_in_memory")
    _ = SweetAlert().showAlert(" ", subTitle: alert_text, style: .success, buttonTitle: TR("OK"), buttonColor: kColorNormalGreen, action: nil)
 
    //wAlert(" ", subTitle: alert_text, style: .success)
}


func TR(_ str: String?) -> String{
     
    if str == nil {
        return kEmpty
    }
    return NSLocalizedString(str!,  comment: " ")
    
}




//MARK: - Games details

func getTabBarTag(_ typeOfGame : Int? = nil) -> Int{
    
    
    if typeOfGame == nil {
        return kTypeTabBarOrder.index(of: local_current_game.type) ?? 0
    } else {
        return kTypeTabBarOrder.index(of: typeOfGame!) ?? 0
    }

}

func recountTimersForLastCounter(_ game : GameInfo) -> (Int, Int) { //now/all/stepType

    let currentTime = getCurrentDateWithUTCTimeZone(Date())
    let realTimDiff =  game.ending_at - currentTime

    if realTimDiff < 0 {
        return (0,0)
    } else {
        return (realTimDiff, realTimDiff)
    }
}


func recountTimersData(_ game : GameInfo) -> (Int, Int, Int) { //now/all/stepType

    let timerNow = game.ending_at - getCurrentDateWithUTCTimeZone(Date())
    let timeAll = game.ending_at - game.started_at
    
    let diff = timerNow //timeAll - timerNow
   
    var typeOfStep = 0

    if game.type != kTypeDay {
        
        typeOfStep =  ( diff > (3600 * 24) ) ? ( diff > (3600 * 24 * 30 ) ? 2 : 1) : 0
        
    }  
    
    if timerNow > 0 {
        return (timerNow,timeAll,typeOfStep)
    } else {
        return (0, 0, -1)
    }
}


func getTextFromFileInfo() -> String? {
    let myFileUrl = Bundle.main.url(forResource: TR("HDIW"), withExtension: "txt")
    let text = try! String(contentsOf: myFileUrl!, encoding: String.Encoding.utf8)
    
    return text
}


//MARK: - NICE STRINGS

func getNiceFullDateFormatString(from timeSec : Int) -> String {
    
//    let currentDate = getCurrentDateWithUTCTimeZone(<#T##date: Date##Date#>)
    
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

let kFakeParallaxShift = CGFloat(200)

func create_fon_view(_ size: CGSize) -> UIImageView {

    
    let bg_view = UIImageView(frame : CGRect(x: -kFakeParallaxShift, y: 0,
                                             width: size.width + kFakeParallaxShift,
                                             height:  size.height))
    
    bg_view.image =  UIImage(named: "bg_1")
    bg_view.contentMode = .scaleAspectFill
//    addParallaxToView(bg_view, Int(amount))
    
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

//MARK: - MY WALLETS

func isMywalletHasTheNumber(_ newAddr : String) -> Bool{
    
    let lowerCased = users_account_wallets.map { $0.smart_contract_id.lowercased() }
    
    return lowerCased.contains(newAddr.lowercased())
}

func getKeyOfMyWallet(_ index : Int) -> String{
 
    return users_account_wallets[index].smart_contract_id
}

func removeKeyfromMyWallet(_ index : Int){
 
    users_account_wallets.remove(at: index)
}

func getKeysOfMyWallets() -> String {
    
    var str_answer = "?"
    
    for item in  users_account_wallets {
        str_answer += "wallets=\(item.smart_contract_id)&"
    }
    
     str_answer.removeLast()
    
    return str_answer
}


func isUserInGame(_ game_id : String) -> Bool{
 
    return users_account_wallets.contains{ $0.active_games.contains(game_id) }
    
}



//MARK: - GAMES_LIST

func getKeysOfCurrentGames() -> [String] {

    return games_list.keys.map { "\($0)" }

}

func getGameType(_ game_id : String) -> Int{
 
    let item = games_list.filter{ $1.game_id == game_id }
    
    if item.count > 0 {
        return item.first!.value.type
    }
    return kTypeUndefined
}

//MARK: - NICE DATA

func getNiceDateFormatString(from timeSec : Int) -> String {
    
    let currentDate = Date(timeIntervalSince1970: TimeInterval(timeSec))
    
    let dateFormatter =  DateFormatter()
    dateFormatter.locale = Locale(identifier: langCodes[current_language_ind])
    dateFormatter.dateFormat = "dd MMMM yyyy, EEEE"
    
    return dateFormatter.string(from: currentDate)
    
    
}

func getNiceDateFormatHistoryString(from timeSec : Int) -> String {
    
    let currentDate = Date(timeIntervalSince1970: TimeInterval(timeSec))
    
    let dateFormatter =  DateFormatter()
    dateFormatter.locale = Locale(identifier: langCodes[current_language_ind])
    dateFormatter.dateFormat = "dd.MM.yy"
    
    return dateFormatter.string(from: currentDate)
}

func getNiceDateFormatShortString(from timeSec : Int) -> String {
    
    let currentDate = Date(timeIntervalSince1970: TimeInterval(timeSec))
    
    let dateFormatter =  DateFormatter()
    dateFormatter.locale = Locale(identifier: langCodes[current_language_ind])
    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    return dateFormatter.string(from: currentDate)
}


func convertDate(from isoDate : String?) -> Int {
    
    if isoDate == nil {
        return 0
    }
    
    let dateFormatter =  DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date =  dateFormatter.date(from: isoDate!)
    
//    let timeZoneOffset = NSTimeZone.system.secondsFromGMT(for: Date())
 
    return Int(date!.timeIntervalSince1970) //- timeZoneOffset
    
}


func getCurrentDateWithUTCTimeZone( _ date : Date ) -> Int {
    
    return Int(date.timeIntervalSince1970)

}

//MARK:UTCStringToDate

func openUrlFromApp(_ path : String ){
    
    let url = URL(string: path)
    
    if url == nil {
        return
    }
    
    if UIApplication.shared.canOpenURL(url!) {
        if #available(iOS 10.0, *) {
           
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

func imageWithView(view: UIImageView) -> UIImage? {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)

    view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
    let img = UIGraphicsGetImageFromCurrentImageContext()
        
    UIGraphicsEndImageContext();
        
    return img
    
}


func setImageForTitle(_ sizeOfView : CGSize, _ imageName : String) -> UIView{
    
    let bgView = UIImageView(frame: CGRect(x: 0, y: 0, width:  sizeOfView.width,
                                           height: sizeOfView.height))
    bgView.backgroundColor = UIColor.clear
    
    bgView.contentMode = .scaleAspectFit
    
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

func playMoney(){
    
    Sound.play(file: "money.mp3")
    
    
}
func playStandart(){
    
    Sound.play(file: "usual.mp3")

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


func saveDeviceSettings(){
    
    MemoryControll.saveObject(notifications_switch, key: "notifications_switch")
    
    NetWork.postDeviceSettings()
}




//MARK: - CRASHLITICS

func sendEvent( _ line : String, _ params : [String : Any]? = nil){
    
    Answers.logCustomEvent(withName: line, customAttributes: params)
}

func message_to_Crashlytics(line : String? = nil, description : String? = nil, body : Any? = nil, error: Error? = nil) -> String {
    
    if error != nil {
        
        Crashlytics.sharedInstance().recordError(error!)
        
    } else {
        
        var params = [String : NSObject]()
        params["function"] = (line ?? kEmpty ) as NSObject
        params["description"] = (description ?? kEmpty ) as NSObject
        params["body"] = String(describing: body) as NSObject
        
        sendEvent("parse_error", params)
        
    }
    
    
    return TR("connectio_error")
}

//MARRK: - Tables sortings

func containsText(_ item : UserForGame, _ searchtext : String) -> Bool {
    
    let search_text = searchtext.lowercased()
    
    let text1 = item.user_id.lowercased()
    let text2 = "\(item.position)"
    let text3 = "\(item.prize_amount)"
    let text4 = "\(item.prize_amount_fiat)"
    
    return  text1.contains(search_text) || text2.contains(search_text) ||
        text3.contains(search_text) || text4.contains(search_text)
    
}

func tableSorting( searchtext: String?, origin_dataForTable : [UserForGame]) -> [UserForGame]{
 
    var dataForTable = [UserForGame]()
    
    if searchtext != nil && Array(searchtext!).count > 0{
        
        dataForTable = origin_dataForTable.filter({ (item : UserForGame) -> Bool in
            
            return containsText(item, searchtext!)
            
        })
        
    } else {
        
        dataForTable = origin_dataForTable
        
    }
    
    return dataForTable
}




func  isAddressEth(_ wallet : String) -> Bool{
 
    
    let pattern = "^(0x)?[0-9a-f]{40}$"

    return wallet.lowercased().matches(pattern)

    
}

func getDaysWord(_ count : Int) -> String {
    
    if count == 1 {
        return TR("day")
    }

    if [2,3,4].contains(count % 10) {
        return TR("days2_1")
    }
    
    return TR("days2_2") 
}



