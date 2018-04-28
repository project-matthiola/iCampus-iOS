//
//  RequestAlertPlugin.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/17.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import Moya
import Result
import PKHUD

final class RequestAlertPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        return
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            let statusCode = response.statusCode
            switch statusCode {
            case 202:
                ErrorHandler().showErrorHUD(subtitle: "请求资源不存在")
            default:
                break
            }
        case let .failure(error):
            ErrorHandler().showErrorHUD(subtitle: error.localizedDescription)
        }
    }
    
}
