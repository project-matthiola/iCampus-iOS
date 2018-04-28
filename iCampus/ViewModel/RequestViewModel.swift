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
    
    func getRequests() -> Observable<[Request]> {
        return provider.rx.request(.getRequest(id: nil))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapArray(type: Request.self, key: "Request")
    }
    
    func getRequest(by id: Int) -> Observable<Request> {
        return provider.rx.request(.getRequest(id: String(id)))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: Request.self)
    }
    
}
