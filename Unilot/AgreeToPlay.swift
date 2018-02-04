//
//  AgreeToPlay.swift
//  Unilot
//
//  Created by Alyona on 9/27/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit  


class AgreeToPlay: PopUpCore, CountDownTimeDelegate {

    @IBOutlet weak var codeButton: UIButton!
 
    @IBOutlet weak var clockTablet: CDTimerPopUp!
    
    
    
    @IBOutlet weak var textBig: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!

    @IBOutlet weak var warningLabel: UILabel!

    @IBOutlet weak var copyButton: UIButton!


    @IBOutlet weak var copy_line: UILabel!

    
    class func createAgreeToPlay() -> AgreeToPlay {
        let myClassNib = UINib(nibName: "AgreeToPlay", bundle: nil)
         return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! AgreeToPlay
    }
    
     override func setInitBorders(){

        super.setInitBorders()
         
        startClock()

        copy_line.text = current_game.smart_contract_id
        
        let image = Barcode.fromString(string: current_game.smart_contract_id, forWidth: codeButton.frame.width)
        
        codeButton.setImage(image, for: .normal)
        codeButton.imageView?.contentMode = .scaleAspectFill
        codeButton.contentMode = .scaleAspectFill

//        let order = getTabBarTag()
//        let lotteryType = TR(setting_strings[0][order]).capitalized + " " + TR("drawing3")
//        titleMain.text = TR(tabbar_strings[order]).capitalized + " " + TR("drawing1") +  " " + app_name.uppercased()
        
//        textBig.text = String(format: TR("to_participate_you_need"),TR(lotteryType),floatBet)
        
        let text_name = "AlertText-" + langCodes[current_language_ind]
        
        if let filepath = Bundle.main.path(forResource: text_name, ofType: "html") {
            do {
                var contents = try String(contentsOfFile: filepath)
                
                contents = String(format: contents, "\(heightOfText())",
                    " \( current_game.bet_amount)", current_game.gas_limit.stringWithSepator, current_game.gas_price.stringWithSepator)
                
                textBig.attributedText = try! NSAttributedString(data: contents.data(using: String.Encoding.utf8, allowLossyConversion: false)!,
                                                                  options: [.documentType: NSAttributedString.DocumentType.html],
                                                                  documentAttributes: nil)
                
            } catch {
                // contents could not be loaded
            }
        }
        
        
        
        endLabel.text = TR("will_be_off_after:")
        
        warningLabel.text = TR("go_back_after_payment")
        
        copyButton.setTitle("  " + TR("copy_address"), for: .normal)
    }
    
    
    func startClock(){
        
        let items = recountTimersData(current_game)
        
        if items.2 > -1 {
            
            clockTablet.createBody(self)
            clockTablet.setTextColor(UIColor.black)
            clockTablet.labelMain.font = UIFont(name: kFont_Regular, size: 400)
            clockTablet.labelMain.frame.origin = CGPoint(x: 0,
                                                         y: -clockTablet.labelMain.frame.height * 0.6)

            clockTablet.initTimer(items.0, items.1)
//            clockTablet.changeTextOnStaticLabels(items.2)
            
            clockTablet.doScheduledTimer()
            
        } else {
            onX()
        }
        
     }
    
    
    
    @IBAction func onBarCode(){

        
    }
    
    @IBAction func onCopyNumber(){

        sendEvent("EVENT_\(kEVENTS_middle[current_game.type]!)_PARTICIPATE_COPY")
        
        saveToClipboard(copy_line.text!)

     }
    
    func countDownDidFall(from: Int, left: Int){
  
    }
    
    func countDownFinished(){
        onX()
    }
    
    
    override func onX(_ duration: Double = 0.4) {
        
        clockTablet.endTimer()
        
        super.onX(duration)
        
        
    }
    
    
    //MARK: - size text
    
    
    func heightOfText() -> CGFloat{
        
        switch UIScreen.main.nativeBounds.size.height {
            
        case 1136:
            //            printf("iPhone 5 or 5S or 5C");
            return 9
            
        case 1334:
            //            printf("iPhone 6/6S/7/8");
            return 15
            
        case 2208:
            //            printf("iPhone 6+/6S+/7+/8+");
            return 17
            
        case 2436:
            //            printf("iPhone X");
            return 17
            
        default:
            return 20
        }
        
    }


}
