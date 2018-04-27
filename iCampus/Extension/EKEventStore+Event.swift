//
//  EKEventStore+Event.swift
//  iCampus
//
//  Created by Yuchen Cheng on 2018/4/27.
//  Copyright © 2018年 Yuchen Cheng. All rights reserved.
//

import Foundation
import EventKit
import PKHUD

protocol iCampusEvent {
    func addEvent()
    func cancelEvent()
}

extension EKEventStore: iCampusEvent {
    
    func addEvent() {
        if let calendarIdentifier = UserDefaults.standard.object(forKey: "calendarIdentifier") as? String, self.calendar(withIdentifier: calendarIdentifier) != nil {
            HUD.flash(.label("Success"), delay: 2.0)
        } else {
            let calender = EKCalendar(for: .event, eventStore: self)
            calender.title = "iCampus"
            calender.cgColor = UIColor(hex6: 0xD0021B).cgColor
            calender.source = self.defaultCalendarForNewEvents?.source
            do {
                try self.saveCalendar(calender, commit: true)
                UserDefaults.standard.set(calender.calendarIdentifier, forKey: "calendarIdentifier")
                UserDefaults.standard.synchronize()
            } catch {
                HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription), delay: 2.0)
            }
        }

        //let calendar = self.defaultCalendarForNewEvents
        //print(calendar?.title)
    }
    
    func cancelEvent() {
        return
    }
    
}
