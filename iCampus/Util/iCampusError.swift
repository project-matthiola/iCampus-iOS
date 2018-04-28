//
//  iCampusError.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/25.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import PKHUD

// swiftlint:disable type_name
enum iCampusError: Error {
    case parseJSONError
    case loginError
}

class ErrorHandler {
    
    func showErrorHUD(subtitle: String?) {
        DispatchQueue.main.async {
            HUD.flash(.labeledError(title: "错误", subtitle: subtitle), delay: 2.0)
        }
    }
    
}
