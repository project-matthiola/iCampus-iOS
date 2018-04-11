//
//  Observable+map.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/11.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Moya

extension Observable {
	func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
		return self.map { response in
			guard let dict = response as? [String: Any] else {
				throw RxSwiftError.parseJSONError
			}
			return Mapper<T>().map(JSON: dict)!
		}
	}
	
	func mapObject<T: Mappable>(type: T.Type, key: String) -> Observable<T> {
		return self.map { response in
			guard let dict = response as? [String: Any], let array = dict[key] as? [[String: Any]] else {
				throw RxSwiftError.parseJSONError
			}
			return Mapper<T>().map(JSON: array[0])!
		}
	}
	
	func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
		return self.map { response in
			guard let array = response as? [Any], let dicts = array as? [[String: Any]] else {
				throw RxSwiftError.parseJSONError
			}
			return Mapper<T>().mapArray(JSONArray: dicts)
		}
	}
}

enum RxSwiftError: Error {
	case parseJSONError
}
