//
//  RequestTransform.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/29.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper

open class RequestTypeTransform: TransformType {

    public typealias Object = RequestType
    public typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> RequestType? {
        if let requestStr = value as? String, let request = RequestType(requestStr) {
            return request
        } else {
            return nil
        }
    }
    
    public func transformToJSON(_ value: RequestType?) -> String? {
        return value?.value
    }
    
}
