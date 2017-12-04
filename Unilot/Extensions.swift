//
//  Extensions.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit


func extraTop() -> CGFloat {
    
    var top: CGFloat = 0
    
    if #available(iOS 11.0, *) {
        
        if let t = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            top = t
        }
    }
    return top
}
extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
//    subscript (i: Int) -> String {
//        return String(self[i] as Character)
//    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
}

func extraBottom() -> CGFloat {
    
    var bottom: CGFloat = 0
    
    if #available(iOS 11.0, *) {
        
        if let b = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            bottom = b
        }
    }
    return bottom
}


extension UIColor {
    @nonobjc class var uuDarkTwo: UIColor {
        return UIColor(red: 14.0 / 255.0, green: 14.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var uuLipstick: UIColor {
        return UIColor(red: 203.0 / 255.0, green: 38.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var uuLightPeach: UIColor {
        return UIColor(red: 1.0, green: 206.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var uuDark: UIColor {
        return UIColor(red: 39.0 / 255.0, green: 39.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var uuLightSalmon: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 173.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
}

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIViewController{
      
    
    func getVCFromName(_ name: String) -> UIViewController{
        
        let storyBoard = UIStoryboard(name: "Main", bundle : nil )
        let contrller = storyBoard.instantiateViewController(withIdentifier: name)
        
        return contrller
    }
    
    
    
    func setNavControllerClear(){
        
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
         
        navigationController?.updateFocusIfNeeded()
        
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
}



@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return  UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return  UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var shadowOpacity:Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowOffset:CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius:CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }

}


extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}



struct Number {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " " // or possibly "." / ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var stringWithSepator: String {
        return Number.withSeparator.string(from: NSNumber(value: hashValue)) ?? ""
    }
}


class MyButton : UIButton{
    var subTag : IndexPath?
}


class MySwitch : UISwitch{
    var subTag : IndexPath?
}

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}


class SpecialItem : UIImageView {
    
    var sizeDiag = CGFloat(20)
    var numberInCircle = UILabel(frame : CGRect(x: 0, y: 0, width: 5 , height: 5))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBadge()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        addBadge()
    }
    
    func addBadge(){
        

        numberInCircle.layer.cornerRadius = sizeDiag/2
        numberInCircle.clipsToBounds = true
        numberInCircle.backgroundColor = kColorBadge
        numberInCircle.textColor = UIColor.white
        numberInCircle.frame =  CGRect(x:  self.frame.size.width - sizeDiag * 0.25,
                                       y: -sizeDiag * 0.25, width: sizeDiag , height: sizeDiag)
        numberInCircle.font = UIFont(name: kFont_Light, size: 12)
        numberInCircle.textAlignment = .center
        numberInCircle.adjustsFontSizeToFitWidth = true
        numberInCircle.isHidden = true
        
        
        addSubview(numberInCircle)
    }
    
    func setCircle(){
        
        sizeDiag = self.frame.width/2
        numberInCircle.layer.cornerRadius = sizeDiag/2
        numberInCircle.clipsToBounds = true
        numberInCircle.backgroundColor = kColorBadge
        numberInCircle.frame =  CGRect(x:  self.frame.size.width - sizeDiag/2,
                                       y:  0 , width: sizeDiag , height: sizeDiag)
        numberInCircle.isHidden = false
        numberInCircle.text = kEmpty
    }
    
    func setNumberLabel(_ number: Int){
        
        
        if number == 0 {
            numberInCircle.isHidden = true
        } else {
            numberInCircle.isHidden = false
            numberInCircle.text = "\(number)"
        }
    }
    
    
    func setCircleMark(_ game_id: String){
        
        if notification_data.filter({
            return game_id == NotifApp.getDataFromNotifString($0, 1)
        
        }).count > 0 {
            setCircle()
        } else {
           numberInCircle.isHidden = true
        }
    
    }

}
 

