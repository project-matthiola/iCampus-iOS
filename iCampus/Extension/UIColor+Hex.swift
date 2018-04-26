//
//  UIColor+Hex.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2017/12/20.
//  Copyright © 2017年 Yuchen Cheng. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
        let blue  = CGFloat(hex6 & 0x0000FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
