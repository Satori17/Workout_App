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
    func toggleMissedWorkout(_ isMissed: Bool, weekDay: String, id: Int)
    func getMissedWorkouts(request: HomeModel.getMissedWorkouts.Request)
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
    
    func getMissedWorkouts(request: HomeModel.getMissedWorkouts.Request) {
        worker?.fetchMissedWorkouts(completion: { result in
            switch result {
            case .success(let missedWorkouts):
                let response = HomeModel.getMissedWorkouts.Response(missedWorkouts: missedWorkouts)
                presenter?.presentMissedWorkouts(response: response)
            case .failure(let error):
                presenter?.didFailPresentMissedWorkouts(withError: error)
            }
        })
    }
}
