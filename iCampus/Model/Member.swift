//
//  Member.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/10.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper

class Member: Mappable {
	var userId: String?
	var password: String?
	var phone: String?
	var role: String?
	var classId: String?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		userId <- map["user_id"]
		password <- map["password"]
		phone <- map["phone"]
		role <- map["role"]
		classId <- map["class_id"]
	}
}
