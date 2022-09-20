//
//  Constants.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 27.07.22.
//

import Foundation

//MARK: - ViewController Ids
enum Ids {
    static let onBoarding = "OnBoardingViewController"
    static let tabBar = "TabBarController"
    static let main = "Main"
    static let home = "HomeViewController"
    static let category = "CategoryViewController"
    static let workouts = "WorkoutsViewController"
    static let workoutDetail = "WorkoutDetailViewController"
    static let WorkoutDetailView = "WorkoutDetailView"
    static let alert = "AlertViewController"
    static let headerView = "WeekDayHeaderView"
}

//MARK: - Notification Center Names
enum NotificationName {
    static let openFromNotification = Notification.Name("com.sabakhitaridze.Workout-App.receiveNotification")
}

//MARK: - User Default Keys
enum UserDefaultKey: String {
    case appLaunched
}
