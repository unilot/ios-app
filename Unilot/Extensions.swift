//
//  Extensions.swift
//  Unilot
//
//  Created by Alyona on 9/26/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

func imageScaledToSize(size: CGSize, image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    image.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
    let imageR = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return imageR!;
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
