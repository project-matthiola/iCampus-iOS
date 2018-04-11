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
	func getMember(userId: String) -> Observable<Member> {
		return provider.rx.request(.getMember(userId: userId))
			.asObservable()
			.filterSuccessfulStatusCodes()
			.mapJSON()
			.mapObject(type: Member.self, key: "Member")
	}
}
