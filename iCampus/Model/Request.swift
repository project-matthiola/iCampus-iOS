//
//  Request.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/27.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

public enum RequestType: String {
    case scholar
    case leave
    
    init?(_ requestType: String) {
        guard let last = requestType.components(separatedBy: "_").last else { return nil }
        self.init(rawValue: last)
    }
    
    var value: String {
        return "TYPE_\(self.rawValue.uppercased)"
    }
}

public enum RequestStatus: String {
    case tbd
    case approved
    case rejected
    
    init?(_ requestStatus: String) {
        guard let last = requestStatus.components(separatedBy: "_").last else { return nil }
        self.init(rawValue: last)
    }
    
    var value: String {
        return "STATUS_\(self.rawValue.uppercased)"
    }
}

class Request: Mappable {
    
    var id: Int!
    var requestType: RequestType?
    var requestTime: Date?
    var text: String?
    var status: RequestStatus?
    var userId: Int!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        requestType <- (map["request_type"], RequestTypeTransform())
        requestTime <- (map["request_time"], CustomDateTransform())
        text <- map["text"]
        status <- (map["status"], RequestStatusTransform())
        userId <- map["user_id"]
    }
    
}

struct SectionOfRequest {
    var items: [Request]
}

extension SectionOfRequest: SectionModelType {
    init(original: SectionOfRequest, items: [Request]) {
        self = original
        self.items = items
    }
}
