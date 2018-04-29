//
//  iCampusPersistence.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/25.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import ObjectMapper
import KeychainAccess

protocol Persistence {
    func saveMember(_ member: Member)
    func deleteMember()
}

// swiftlint:disable type_name
class iCampusPersistence: Persistence {
    
    private let keychain = Keychain(service: "com.rudeigerc.iCampus")
    
    func saveMember(_ member: Member) {
        deleteMember()
        UserDefaults.standard.set(member.toJSON(), forKey: "member")
        UserDefaults.standard.synchronize()
    }
    
    func deleteMember() {
        UserDefaults.standard.removeObject(forKey: "member")
    }
    
    func getMember() -> Member? {
        guard let JSON = UserDefaults.standard.object(forKey: "member") as? [String: Any] else { return nil }
        return Mapper<Member>().map(JSON: JSON)
    }
    
    func isLogin() -> Bool {
        return UserDefaults.standard.object(forKey: "member") != nil
    }
    
}
