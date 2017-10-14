//
//  Extensions.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

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
        return CGSize(width: UIScreen.main.bounds.width, height: 80)
    }
}


extension UIViewController{
     
    
    @IBAction func onLeftMenuBarButton(_ sender : UIBarButtonItem){
        
       openMenu(sender)
    }
    
    func createMenuButton() -> UIBarButtonItem{
        
        let frameBarButton = CGSize(width: 20, height: 20)
        
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(TabBarController.openMenu(_:)) )
        
        
        let viewCustom = setColorForImage(frameBarButton, "menu")
        viewCustom.addGestureRecognizer(tapRecognizer)
        
        return  UIBarButtonItem(customView: viewCustom)
    }
    
    
    func openMenu(_ sender : Any){
        if revealViewController() != nil {
            revealViewController().revealToggle(sender)
        }
    }
    
    
    func getVCFromName(_ name: String) -> UIViewController{
        
        let storyBoard = UIStoryboard(name: "Main", bundle : nil )
        let contrller = storyBoard.instantiateViewController(withIdentifier: name)
        
        return contrller
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
