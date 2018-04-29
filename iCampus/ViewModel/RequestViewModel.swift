//
//  RequestViewModel.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/28.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import RxSwift

class RequestViewModel {
    
    func getRequests(by userId: String) -> Observable<[Request]> {
        return provider.rx.request(.getRequests(userId: userId))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapArray(type: Request.self, key: "Request")
    }
    
    func addRequest(requestType: RequestType, text: String, userId: String) -> Observable<Bool> {
        return provider.rx.request(.addRequest(requestType: requestType.value, text: text, userId: userId))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: Request.self)
            .map { $0.id != nil }
    }
    
}
