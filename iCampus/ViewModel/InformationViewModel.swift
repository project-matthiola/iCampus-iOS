//
//  InformationViewModel.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/17.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import RxSwift

class InformationViewModel {
    
    func getInformations() -> Observable<[Information]> {
        return provider.rx.request(.getInformation(id: nil))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .catchErrorJustReturn([])
            .mapArray(type: Information.self, key: "Information")
    }
    
    func getInformation(by id: Int) -> Observable<Information> {
        return provider.rx.request(.getInformation(id: String(id)))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: Information.self)
    }
    
}
