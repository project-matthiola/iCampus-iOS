//
//  News.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/27.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class News: Mappable {
    
    var id: Int!
    var newsTime: Date?
    var title: String?
    var author: String?
    var text: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        newsTime <- map["news_time"]
        title <- map["title"]
        author <- map["author"]
        text <- map["text"]
    }
    
}

struct SectionOfNews {
    var items: [News]
}

extension SectionOfNews: SectionModelType {
    init(original: SectionOfNews, items: [News]) {
        self = original
        self.items = items
    }
}
