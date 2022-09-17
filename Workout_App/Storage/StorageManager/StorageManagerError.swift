//
//  StorageManagerError.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

enum StorageManagerError: String, Error {
    case managedContextFailed
    case fetchFailed = "Error happened while fetching saved workouts, Please Reload."
    case saveWorkoutFailed = "Error happened while saving workout"
    case saveScheduleFailed = "Error happened while saving week day schedule"
    case removeWorkoutFailed = "Error happened while removing workout"
    case removeScheduleFailed = "Error happened while removing week day schedule"
    case toggleMissedWorkoutFailed = "Error happened while toggling missed workout"
}
