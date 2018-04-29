//
//  GradeViewModel.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/27.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import RxSwift

class GradeViewModel {
    
    func getGrades(userId: String) -> Observable<[Grade]> {
        return provider.rx.request(.getGrades(userId: userId))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .catchErrorJustReturn([])
            .mapArray(type: Grade.self, key: "Grade")
    }
    
    func getCourseNames(grades: [Grade]) -> Observable<[Grade]> {
        return Observable.from(grades)
            .map(getCourse)
            .concat()
            .toArray()
    }
    
    fileprivate func getCourse(by grade: Grade) -> Observable<Grade> {
        return provider.rx.request(.getCourse(courseId: grade.courseId!))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: Grade.self, key: "Course")
            .map {
                grade.courseName = $0.courseName
                return grade
            }
    }
    
}
