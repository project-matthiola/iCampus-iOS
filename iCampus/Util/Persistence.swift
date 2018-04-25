//
//  Persistence.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/25.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation

public protocol Persistence {
	func saveId(_ id: Int)
	func deleteId()
}

// swiftlint:disable type_name
public class iCampusPersistence: Persistence {
	
	public func saveId(_ id: Int) {
		deleteId()
		UserDefaults.standard.set(id, forKey: "id")
		UserDefaults.standard.synchronize()
	}
	
	public func deleteId() {
		UserDefaults.standard.removeObject(forKey: "id")
	}
	
	public func getId() -> Int? {
		guard let id = UserDefaults.standard.object(forKey: "id") as? Int else { return nil }
		return id
	}
	
	public func isLogin() -> Bool {
		return UserDefaults.standard.object(forKey: "id") as? Int != nil
	}

}
