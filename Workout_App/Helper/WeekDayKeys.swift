//
//  WeekDayKeys.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 11.09.22.
//

import UIKit

enum WeekDay {
    static let monday = "Monday"
    static let tuesday = "Tuesday"
    static let wednesday = "Wednesday"
    static let thursday = "Thursday"
    static let friday = "Friday"
    static let saturday = "Saturday"
    static let sunday = "Sunday"
}

enum WeekDayKeys {
    
    static let weekDaysDict = [
        WeekDay.sunday: 1,
        WeekDay.monday: 2,
        WeekDay.tuesday: 3,
        WeekDay.wednesday: 4,
        WeekDay.thursday: 5,
        WeekDay.friday: 6,
        WeekDay.saturday: 7
    ]
}
