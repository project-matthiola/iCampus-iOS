//
//  CardView.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/27.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import UIKit

class CardView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }

}
