//
//  News.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/17.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper

class News: Mappable {
	var id: String!
	var title: String?
	var informationTime: Date?
	var place: String?
	var text: String?
	var source: String?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		id <- map["map"]
		title <- map["title"]
		informationTime <- map["information_time"]
		place <- map["place"]
		text <- map["text"]
		source <- map["source"]
	}	
}
