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
    func addEvent(information: Information, alertTime: Date?)
    func cancelEvent()
}

extension EKEventStore: iCampusEvent {
    
    func addEvent(information: Information, alertTime: Date?) {
        if let calendarIdentifier = UserDefaults.standard.object(forKey: "calendarIdentifier") as? String, self.calendar(withIdentifier: calendarIdentifier) == nil {
            UserDefaults.standard.removeObject(forKey: "calendarIdentifier")
        }
        
        if UserDefaults.standard.object(forKey: "calendarIdentifier") == nil {
            let calender = EKCalendar(for: .event, eventStore: self)
            calender.title = "iCampus"
            calender.cgColor = UIColor.iCampus.cgColor
            calender.source = self.defaultCalendarForNewEvents?.source
            do {
                try self.saveCalendar(calender, commit: true)
                UserDefaults.standard.set(calender.calendarIdentifier, forKey: "calendarIdentifier")
                UserDefaults.standard.synchronize()
            } catch {
                ErrorHandler().showErrorHUD(subtitle: error.localizedDescription)
            }
        }
        
        if let calendarIdentifier = UserDefaults.standard.object(forKey: "calendarIdentifier") as? String, let calendar = self.calendar(withIdentifier: calendarIdentifier) {
            let event = EKEvent(eventStore: self)
            event.calendar = calendar
            event.title = information.title
            event.startDate = information.informationTime
            event.endDate = information.informationTime!.addingTimeInterval(TimeInterval(2 * 60 * 60))
            event.location = information.place
            event.notes = information.source
            
            if alertTime != nil {
                event.addAlarm(EKAlarm(absoluteDate: alertTime!))
            } else {
                event.addAlarm(EKAlarm(relativeOffset: TimeInterval(-30 * 60)))
            }
            
            do {
                try self.save(event, span: .thisEvent, commit: true)
            } catch {
                ErrorHandler().showErrorHUD(subtitle: error.localizedDescription)
            }
        }
    }
    
    func cancelEvent() {
        return
    }
    
}
