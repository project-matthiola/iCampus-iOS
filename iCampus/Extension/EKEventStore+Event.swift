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
    func addEvent(title: String, startDate: Date, endDate: Date)
    func cancelEvent()
}

extension EKEventStore: iCampusEvent {
    
    func addEvent(title: String, startDate: Date, endDate: Date) {
        if let calendarIdentifier = UserDefaults.standard.object(forKey: "calendarIdentifier") as? String, self.calendar(withIdentifier: calendarIdentifier) == nil {
            UserDefaults.standard.removeObject(forKey: "calendarIdentifier")
        }
        
        if UserDefaults.standard.object(forKey: "calendarIdentifier") == nil {
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
        
        if let calendarIdentifier = UserDefaults.standard.object(forKey: "calendarIdentifier") as? String, let calendar = self.calendar(withIdentifier: calendarIdentifier) {
            let event = EKEvent(eventStore: self)
            event.calendar = calendar
            event.title = title
            event.startDate = startDate
            event.endDate = startDate.addingTimeInterval(TimeInterval(2 * 60 * 60))
            event.addAlarm(EKAlarm(relativeOffset: TimeInterval(-30 * 60)))
            do {
                try self.save(event, span: .thisEvent, commit: true)
            } catch {
                HUD.flash(.labeledError(title: "错误", subtitle: error.localizedDescription), delay: 2.0)
            }
        }
    }
    
    func cancelEvent() {
        
    }
    
}
