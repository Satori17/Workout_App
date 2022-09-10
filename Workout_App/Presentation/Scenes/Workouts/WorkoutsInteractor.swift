//
//  WorkoutsInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

protocol WorkoutsBusinessLogic {
    func getWorkouts(request: WorkoutModel.GetWorkouts.Request)
    func showWorkoutDetails(request: WorkoutModel.ShowWorkoutDetails.Request)
    func showSaveAlert(request: WorkoutModel.ShowSaveAlert.Request)
}

protocol WorkoutsDataStore {
    var selectedWorkout: WorkoutViewModel? { get }
    var isTransitionAnimated: Bool? { get }
}

final class WorkoutsInteractor: WorkoutsDataStore {
    //clean components
    var presenter: WorkoutsPresentationLogic?
    var worker: WorkoutsWorker?
    private(set) var selectedWorkout: WorkoutViewModel?
    private(set) var isTransitionAnimated: Bool?

}


extension WorkoutsInteractor: WorkoutsBusinessLogic {
    
    func getWorkouts(request: WorkoutModel.GetWorkouts.Request) {
        Task {
            do {
                let workouts = try await worker?.fetchWorkouts()
                DispatchQueue.main.async { [weak self] in
                    if let workouts = workouts {
                        let categorizedWorkouts = workouts.filter{ $0.category?.id == request.categoryId }
                        let response = WorkoutModel.GetWorkouts.Response(workouts: categorizedWorkouts)                        
                        self?.presenter?.presentWorkouts(response: response)
                    }
                }
            } catch(let error) {
                if let fetchError = error as? FetchingError {
                self.presenter?.didFailPresentWorkouts(withError: fetchError)
                }
            }
        }
    }
    
    func showWorkoutDetails(request: WorkoutModel.ShowWorkoutDetails.Request) {
        self.selectedWorkout = request.workout
        self.isTransitionAnimated = request.isAnimated
        let response = WorkoutModel.ShowWorkoutDetails.Response()
        presenter?.presentWorkoutDetails(response: response)
    }
    
    func showSaveAlert(request: WorkoutModel.ShowSaveAlert.Request) {
        self.selectedWorkout = request.workout
        presenter?.presentSaveAlert(response: WorkoutModel.ShowSaveAlert.Response())
        
    }
    
}
