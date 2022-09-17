//
//  WorkoutsWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

protocol WorkoutsWorkerLogic {    
    func fetchWorkouts() async throws -> [Workout]
}

final class WorkoutsWorker: WorkoutsWorkerLogic {
    
    func fetchWorkouts() async throws -> [Workout] {
        let data = try await Fetcher.shared.fetchData(with: WorkoutUrlBuilder.shared, as: WorkoutData<Workout>.self)
        guard let workouts = data.results else { throw FetchingError.dataError }
        
        return workouts
    }
}
