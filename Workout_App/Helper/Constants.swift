//
//  Constants.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 27.07.22.
//

import Foundation

enum Ids {
    static let home = "HomeViewController"
    static let category = "CategoryViewController"
    static let workouts = "WorkoutsViewController"
    static let workoutDetail = "WorkoutDetailViewController"
    static let alert = "AlertViewController"
    static let headerView = "WeekDayHeaderView"
}

enum NotificationName {
    static let openFromNotification = Notification.Name("com.sabakhitaridze.Workout-App.receiveNotification")
}
