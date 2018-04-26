//
//  MemberViewModel.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/11.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import RxSwift

class MemberViewModel {
    
    func getMember(id: Int) -> Observable<Member> {
        return provider.rx.request(.getMember(id: id))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: Member.self)
    }
    
    func signup(userId: String, password: String, phone: String) -> Observable<Bool> {
        return provider.rx.request(.addMember(userId: userId, password: password, phone: phone))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: Member.self)
            .map { $0.id != nil }
    }
    
    func login(userId: String, password: String) -> Observable<Member> {
        return provider.rx.request(.login(userId: userId))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: Member.self, key: "Member")
    }
    
    func updateMember(member: Member) -> Observable<Bool> {
        return provider.rx.request(.updateMember(id: member.id, userId: member.userId, password: member.password, phone: member.phone, role: member.role, classId: member.classId, name: member.name))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: Member.self)
            .map { $0.id != nil }
    }
    
}
