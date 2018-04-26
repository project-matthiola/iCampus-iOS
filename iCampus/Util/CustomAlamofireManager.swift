//
//  CustomAlamofireManager.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/19.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import Alamofire

class CustomAlamofireManeger {
    
    static func manager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 5
        let manager = Alamofire.SessionManager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }
    
}
