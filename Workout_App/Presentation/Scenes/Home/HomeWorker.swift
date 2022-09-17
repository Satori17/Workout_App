//
//  HomeWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomeWorkerLogic {
    func fetchSavedWorkouts(completion: (Result<[CoreWorkout], StorageManagerError>) -> Void)
    func removeSavedWorkout(withId id: Int, completion: (Result<Bool, StorageManagerError>) -> Void)
    func toggleMissedWorkout(_ isMissed: Bool, weekDay: String, id: Int, completion: (StorageManagerError) -> Void)
    func fetchMissedWorkouts(completion: (Result<[CoreWorkout], StorageManagerError>) -> Void)
}

final class HomeWorker {
    
    //MARK: - Storage Manager
    private var storageManager: WorkoutStorageManagerLogic?
    
    init(storageManager: WorkoutStorageManager) {
        self.storageManager = storageManager
    }
}

extension HomeWorker: HomeWorkerLogic {
    
    func fetchSavedWorkouts(completion: (Result<[CoreWorkout], StorageManagerError>) -> Void) {
        do {
            guard let allWorkouts = try storageManager?.getAllWorkouts() else { return }
            completion(.success(allWorkouts))
        } catch {
            completion(.failure(.fetchFailed))
        }
    }
    
    func removeSavedWorkout(withId id: Int, completion: (Result<Bool, StorageManagerError>) -> Void) {
        do {
            try storageManager?.removeWorkout(withId: id)
            completion(.success(true))
        } catch {
            completion(.failure(.removeWorkoutFailed))
        }
    }
    
    func toggleMissedWorkout(_ isMissed: Bool, weekDay: String, id: Int, completion: (StorageManagerError) -> Void) {
        do {
            try storageManager?.toggleMissedWorkout(isMissed, weekDay: weekDay, id: id)
        } catch {
            completion(.toggleMissedWorkoutFailed)
        }
    }
    
    func fetchMissedWorkouts(completion: (Result<[CoreWorkout], StorageManagerError>) -> Void) {
        do {
            guard let missedWorkouts = try storageManager?.getAllMissedWorkouts() else { return }
            completion(.success(missedWorkouts))
        } catch {
            completion(.failure(.fetchFailed))
        }
    }
}
