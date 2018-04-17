//
//  ApiService.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/11.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import Moya

let provider = MoyaProvider<iCampusApi>(plugins: [RequestAlertPlugin()])

// swiftlint:disable type_name
enum iCampusApi {
	case getMember(id: String)
	case addMember(userId: String, password: String, phone: String)
	case updateMember(id: String, userId: String, password: String, phone: String, role: String, classId: String, name: String)
	case getInformation(id: String?)
}

extension iCampusApi: TargetType {

	var baseURL: URL {
		return URL(string: "")!
	}
	
	var path: String {
		switch self {
		case .addMember:
			return "/Member"
		case .getMember(let id), .updateMember(let id, _, _, _, _, _, _):
			return "/Member/\(id)"
		case .getInformation(let id):
			return "/Information/\(id ?? "")"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .getMember, .getInformation:
			return .get
		case .addMember:
			return .post
		case .updateMember:
			return .put
		}
	}
	
	var sampleData: Data {
		return "".data(using: .utf8)!
	}
	
	var task: Task {
		switch self {
		case .getMember, .getInformation:
			return .requestPlain
		case let .addMember(userId, password, phone):
			return .requestParameters(parameters: [
				"user_id": userId,
				"password": password,
				"phone": phone,
				"role": "ROLE_STUDENT"
				], encoding: JSONEncoding.default
			)
		case let .updateMember(_, userId, password, phone, role, classId, name):
			return .requestParameters(parameters: [
				"user_id": userId,
				"password": password,
				"phone": phone,
				"role": role,
				"class_id": classId,
				"name": name
				], encoding: JSONEncoding.default
			)

		}
	}
	
	var headers: [String: String]? {
		return ["Content-type": "application/json"]
	}

}
