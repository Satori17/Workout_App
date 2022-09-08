//
//  HomeInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomeBusinessLogic {
    func getSavedWorkouts(request: HomeModel.GetSavedWorkouts.Request)
    func getSavedWorkoutDetails(request: HomeModel.ShowSavedWorkoutDetails.Request)
    func removeWorkout(withId id: Int)
}

protocol HomeDataStore {
    var selectedSavedWorkout: CoreWorkoutViewModel? { get }    
}

class HomeInteractor: HomeDataStore {
    //clean components
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    private(set) var selectedSavedWorkout: CoreWorkoutViewModel?
    //storage manager
    var storageManager: WorkoutStorageManager?
    
}

extension HomeInteractor: HomeBusinessLogic {
    
    func getSavedWorkouts(request: HomeModel.GetSavedWorkouts.Request) {
        worker?.fetchSavedWorkouts(completion: { result in
            switch result {
            case .success(let savedWorkouts):
                let response = HomeModel.GetSavedWorkouts.Response(savedWorkouts: savedWorkouts)
                presenter?.presentSavedWorkouts(response: response)
            case .failure(let error):
                presenter?.didFailPresentSavedWorkouts(withError: error)
            }
        })
    }
    
    func getSavedWorkoutDetails(request: HomeModel.ShowSavedWorkoutDetails.Request) {
        self.selectedSavedWorkout = request.savedWorkout
        let response = HomeModel.ShowSavedWorkoutDetails.Response()
        presenter?.presentSavedWorkoutDetails(response: response)
    }
    
    func removeWorkout(withId id: Int) {
        do {
            try storageManager?.removeWorkout(withId: id)
        } catch {
            //TODO: - FIX THIS with alerts
            print(StorageManagerError.removeFailed)
        }
    }
    
}
