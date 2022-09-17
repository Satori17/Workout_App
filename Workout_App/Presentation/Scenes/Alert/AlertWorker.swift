//
//  AlertWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

protocol alertWorkerLogic {
    func fetchWorkoutIntensityData() -> (sets: [String], reps: [String], weekDays: [String])
    func saveWorkoutToStorage(model: Displayable, sets: Int, reps: Int, weekDay: WeekDayModel, completion: (StorageManagerError) -> Void)
}

final class AlertWorker {
    
    //MARK: - Properties
    private let sets = Array(1...20).map { String($0) }
    private let reps = Array(1...50).map { String($0) }
    private let weekDays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    ]
    
    //MARK: - Storage Manager
    private var storageManager: WorkoutStorageManagerLogic?
    
    init(storageManager: WorkoutStorageManager) {
        self.storageManager = storageManager
    }
}

extension AlertWorker: alertWorkerLogic {
    
    func fetchWorkoutIntensityData() -> (sets: [String], reps: [String], weekDays: [String]) {
        (sets, reps, weekDays)
    }
    
    func saveWorkoutToStorage(model: Displayable, sets: Int, reps: Int, weekDay: WeekDayModel, completion: (StorageManagerError) -> Void) {
        do {
            let _ = try storageManager?.addWorkout(fromModel: model, sets: sets, reps: reps, weekDay: weekDay)
        } catch {
            completion(.saveWorkoutFailed)
        }
    }
}
