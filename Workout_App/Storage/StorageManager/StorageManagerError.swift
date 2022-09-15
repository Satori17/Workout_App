//
//  StorageManagerError.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

enum StorageManagerError: Error {
    case managedContextFailed
    case fetchFailed
    case saveWorkoutFailed
    case saveScheduleFailed
    case removeWorkoutFailed
    case removeScheduleFailed
    case addToMissedWorkoutFailed
}
