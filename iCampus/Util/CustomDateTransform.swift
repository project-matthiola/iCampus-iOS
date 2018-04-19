//
//  CustomDateTransform.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/18.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper

open class CustomDateTransform: TransformType {
	
	public typealias Object = Date
	public typealias JSON = String
	private let dateFormatter = DateFormatter()
	
	public init() {
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormatter.timeZone = TimeZone(abbreviation: "CCT")
	}
	
	public func transformFromJSON(_ value: Any?) -> Date? {
		if let timeStr = value as? String {
			return dateFormatter.date(from: timeStr)
		} else {
			return nil
		}
	}
	
	public func transformToJSON(_ value: Date?) -> String? {
		return dateFormatter.string(from: value ?? Date(timeIntervalSince1970: TimeInterval(0)))
	}
	
}
