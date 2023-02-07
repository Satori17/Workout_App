//
//  HomeInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomeBusinessLogic {
    func checkUserPermission(request: HomeModel.checkUserPermission.Request)
    func getCoreWorkouts(request: HomeModel.GetSavedWorkouts.Request)
    func getSavedWorkoutDetails(request: HomeModel.ShowSavedWorkoutDetails.Request)
    func removeWorkout(withId id: Int)
    func toggleMissedWorkout(_ isMissed: Bool, weekDay: String, id: Int)
}

protocol HomeDataStore {
    var selectedSavedWorkout: CoreWorkoutViewModel? { get }
}

final class HomeInteractor: HomeDataStore {
    
    //MARK: - Clean Components
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerLogic?
    
    //MARK: - DataStore
    private(set) var selectedSavedWorkout: CoreWorkoutViewModel?
}

//MARK: - Business Logic protocol
extension HomeInteractor: HomeBusinessLogic {
    
    func checkUserPermission(request: HomeModel.checkUserPermission.Request) {
        if !request.granted {
            presenter?.presentCheckUserPermission(response: HomeModel.checkUserPermission.Response())
        }
    }
    
    func getCoreWorkouts(request: HomeModel.GetSavedWorkouts.Request) {
        request.index == 0 ? getSavedWorkouts() : getMissedWorkouts()
    }
    
    func getSavedWorkoutDetails(request: HomeModel.ShowSavedWorkoutDetails.Request) {
        self.selectedSavedWorkout = request.savedWorkout
        let response = HomeModel.ShowSavedWorkoutDetails.Response()
        presenter?.presentSavedWorkoutDetails(response: response)
    }
    
    func removeWorkout(withId id: Int) {
        worker?.removeSavedWorkout(withId: id, completion: { result in
            switch result {
            case .success(_):
                presenter?.presentRemoveWorkoutAlert(withMessage: AlertKeys.removeSuccess)
            case .failure(let error):
                presenter?.didFailPresentRemoveWorkoutAlert(withError: error)
            }
        })
    }
    
    func toggleMissedWorkout(_ isMissed: Bool, weekDay: String, id: Int) {
        worker?.toggleMissedWorkout(isMissed, weekDay: weekDay, id: id, completion: { error in
            presenter?.didFailPresentToggleMissedWorkout(withError: error)
        })
    }
}

//MARK: - Helper methods for saved and missed workouts
private extension HomeInteractor {
    
    func getSavedWorkouts() {
        worker?.fetchSavedWorkouts(completion: { result in
            switch result {
            case .success(let savedWorkouts):
                let response = HomeModel.GetSavedWorkouts.Response(savedWorkouts: savedWorkouts)
                presenter?.presentCoreWorkouts(response: response)
            case .failure(let error):
                presenter?.didFailPresentSavedWorkouts(withError: error)
            }
        })
    }
    
    func getMissedWorkouts() {
        worker?.fetchMissedWorkouts(completion: { result in
            switch result {
            case .success(let missedWorkouts):
                let response = HomeModel.GetSavedWorkouts.Response(savedWorkouts: missedWorkouts)
                presenter?.presentCoreWorkouts(response: response)
            case .failure(let error):
                presenter?.didFailPresentSavedWorkouts(withError: error)
            }
        })
    }
}
