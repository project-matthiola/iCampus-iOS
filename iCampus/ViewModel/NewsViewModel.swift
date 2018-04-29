//
//  NewsViewModel.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/28.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import RxSwift

class NewsViewModel {
    
    func getNews() -> Observable<[News]> {
        return provider.rx.request(.getNews(id: nil))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .catchErrorJustReturn([])
            .mapArray(type: News.self, key: "News")
    }
    
    func getNews(by id: Int) -> Observable<News> {
        return provider.rx.request(.getNews(id: String(id)))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: News.self)
    }
    
}
