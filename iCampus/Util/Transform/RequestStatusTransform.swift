//
//  RequestStatusTransform.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/29.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper

open class RequestStatusTransform: TransformType {
    
    public typealias Object = RequestStatus
    public typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> RequestStatus? {
        if let requestStr = value as? String, let request = RequestStatus(requestStr) {
            return request
        } else {
            return nil
        }
    }
    
    public func transformToJSON(_ value: RequestStatus?) -> String? {
        return value?.value
    }
    
}
