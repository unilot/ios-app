//
//  Extensions.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

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
}


extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

func imageScaledToSize(size: CGSize, image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    image.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
    let imageR = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return imageR!;
}



func TR(_ str: String?) -> String{
    
    
    if str == nil {
        return kEmpty
    }
    return NSLocalizedString(str!,  comment: " ")
    
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

func setImageForTitle(_ sizeOfView : CGSize, _ imageName : String) -> UIView{
    
    let bgView = UIImageView(frame: CGRect(x: 0, y: 0, width:  sizeOfView.width,
                                      height: sizeOfView.height))
    bgView.backgroundColor = UIColor.clear
    
    bgView.image = UIImage(named: imageName)
    
    return bgView
}

func setColorForImage(_ sizeOfView : CGSize, _ imageName : String) -> UIView{
    
    let bgView = UIView(frame: CGRect(x: 0, y: 0, width:  sizeOfView.width,
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
    
    return bgView
}


