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

	func getMember(id: String) -> Observable<Member> {
		return provider.rx.request(.getMember(id: id))
			.asObservable()
			.filterSuccessfulStatusCodes()
			.mapJSON()
			.mapObject(type: Member.self)
	}
	
	func signup(userId: String, password: String, phone: String) -> Observable<Member> {
		return provider.rx.request(.addMember(userId: userId, password: password, phone: phone))
			.asObservable()
			.filterSuccessfulStatusCodes()
			.mapJSON()
			.mapObject(type: Member.self, key: "Member")
	}

}
