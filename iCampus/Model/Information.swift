//
//  News.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/17.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class Information: Mappable {
    
    var id: Int!
    var title: String?
    var informationTime: Date?
    var place: String?
    var text: String?
    var source: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        informationTime <- (map["information_time"], CustomDateTransform())
        place <- map["place"]
        text <- map["text"]
        source <- map["source"]
    }
    
}

struct SectionOfInformation {
    var items: [Information]
}

extension SectionOfInformation: SectionModelType {
    init(original: SectionOfInformation, items: [Information]) {
        self = original
        self.items = items
    }
}
