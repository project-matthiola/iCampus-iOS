//
//  ApiService.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/11.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import Moya

let provider = MoyaProvider<iCampusApi>(manager: CustomAlamofireManeger.manager(), plugins: [RequestAlertPlugin()])

// swiftlint:disable type_name
enum iCampusApi {
    case getMember(id: Int)
    case addMember(userId: String, password: String, phone: String)
    case updateMember(id: Int, userId: String?, password: String?, phone: String?, role: String?, classId: String?, name: String?)
    case getInformation(id: String?)
    case login(userId: String)
    case getGrades(userId: String)
    case getCourse(courseId: String)
    case getNews(id: String?)
    case getRequest(id: String?)
    case addRequest(requestType: String?, text: String?, userId: String)
}

extension iCampusApi: TargetType {
    
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .addMember, .login:
            return "/Member"
        case .getMember(let id), .updateMember(let id, _, _, _, _, _, _):
            return "/Member/\(id)"
        case .getInformation(let id):
            return "/Information/\(id ?? "")"
        case .getGrades:
            return "/Grade"
        case .getCourse:
            return "/Course"
        case .getNews(let id):
            return "/News/\(id ?? "")"
        case .addRequest:
            return "Request"
        case .getRequest(let id):
            return "/Request/\(id ?? "")"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMember, .getInformation, .login, .getGrades, .getCourse, .getNews, .getRequest:
            return .get
        case .addMember, .addRequest:
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
        case .getMember, .getInformation, .getNews, .getRequest:
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
            var params: [String: Any] = [:]
            params["user_id"] = userId
            params["password"] = password
            params["phone"] = phone
            params["role"] = role
            params["class_id"] = classId
            params["name"] = name
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .login(userId):
            return .requestParameters(parameters: ["Member.user_id": userId], encoding: URLEncoding.queryString)
        case let .getGrades(userId):
            return .requestParameters(parameters: ["Grade.user_id": userId], encoding: URLEncoding.queryString)
        case let .getCourse(courseId):
            return .requestParameters(parameters: ["Course.course_id": courseId], encoding: URLEncoding.queryString)
        case let .addRequest(requestType, text, userId):
            var params: [String: Any] = [:]
            params["request_type"] = requestType
            params["request_time"] = Date()
            params["text"] = text
            params["status"] = "STATUS"
            params["user_id"] = userId
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
}
