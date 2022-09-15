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
    func isMissedWorkout(_ isMissed: Bool, weekDay: String)
}

protocol HomeDataStore {
    var selectedSavedWorkout: CoreWorkoutViewModel? { get }    
}

final class HomeInteractor: HomeDataStore {
    
    //MARK: - Clean Components
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    
    //MARK: - DataStore
    private(set) var selectedSavedWorkout: CoreWorkoutViewModel?
    
    //MARK: - Storage Manager
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
            print(StorageManagerError.removeWorkoutFailed)
        }
    }
    
    func isMissedWorkout(_ isMissed: Bool, weekDay: String) {
        do {
            try storageManager?.addMissedWorkout(isMissed, weekDay: weekDay)
        } catch {
            //TODO: - FIX  THIS with alerts
            print(StorageManagerError.addToMissedWorkoutFailed)
        }
    }
}
