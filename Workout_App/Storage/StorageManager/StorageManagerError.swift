//
//  StorageManagerError.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

enum StorageManagerError: Error {
    case managedContextFailed
    case addFailed
    case saveFailed
    case removeFailed
    case editFailed
    case fetchFailed
    case addToFavoritesFailed
}
