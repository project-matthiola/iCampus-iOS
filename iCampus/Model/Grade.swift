//
//  Grade.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/27.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class Grade: Mappable {
    
    var courseId: String?
    var courseName: String?
    var score: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        courseId <- map["course_id"]
        courseName <- map["course_name"]
        score <- map["score"]
    }
    
}

struct SectionOfGrade {
    var items: [Grade]
}

extension SectionOfGrade: SectionModelType {
    init(original: SectionOfGrade, items: [Grade]) {
        self = original
        self.items = items
    }
}
