//
//  HomeWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomeWorkerLogic {
    func fetchSavedWorkouts(completion: (Result<[CoreWorkout], StorageManagerError>) -> Void)
}

final class HomeWorker {
    
    //MARK: - Storage Manager
    private var storageManager: WorkoutStorageManager?
    
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
            completion(.failure(StorageManagerError.fetchFailed))
        }
    }
}
