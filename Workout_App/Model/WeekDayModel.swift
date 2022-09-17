//
//  WeekDayModel.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 12.09.22.
//

import Foundation

struct WeekDayModel: Equatable, Hashable {
    
    static func ==(lhs: WeekDayModel, rhs: WeekDayModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    let name: String
    let scheduledTime: String?
    var isScheduled: Bool = false
    
    init(name: String, scheduledTime: String? = nil) {
        self.name = name
        self.scheduledTime = scheduledTime
        if let scheduledTime = scheduledTime, scheduledTime != "+" {
            isScheduled = true
        }
    }
}
