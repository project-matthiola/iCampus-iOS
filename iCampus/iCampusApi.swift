//
//  ApiService.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/11.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import Moya

let provider = MoyaProvider<iCampusApi>()

// swiftlint:disable type_name
enum iCampusApi {
	case getMember(userId: String)
}

extension iCampusApi: TargetType {
	var baseURL: URL {
		return URL(string: "")!
	}
	
	var path: String {
		switch self {
		case .getMember(_):
			return "/Member"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .getMember:
			return .get
		}
	}
	
	var sampleData: Data {
		switch self {
		case .getMember(_):
			return "".data(using: .utf8)!
		}
	}
	
	var task: Task {
		switch self {
		case let .getMember(userId):
			return .requestParameters(parameters: ["Member.user_id": userId], encoding: URLEncoding.queryString)
		}
	}
	
	var headers: [String: String]? {
		return ["Content-type": "application/json"]
	}
}
