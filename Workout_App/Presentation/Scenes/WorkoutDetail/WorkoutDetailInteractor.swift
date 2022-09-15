//
//  WorkoutDetailInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit

protocol WorkoutDetailBusinessLogic {
    func showWorkoutDetails(request: WorkoutDetailModel.GetWorkoutDetails.Request)
    func showWorkoutLicense(request: WorkoutDetailModel.GetLicense.Request)
    func showSaveAlert(request: WorkoutDetailModel.ShowSaveAlert.Request)
}

protocol WorkoutDetailDataStore {
    var workout: Displayable? { get set }
}

final class WorkoutDetailInteractor {
    
    //MARK: - Clean Components
    var presenter: WorkoutDetailPresentationLogic?
    var worker: WorkoutDetailWorker?
    
    //MARK: - DataStore Properties
    var workout: Displayable?
    
    //MARK: - Storage Manager
    var storageManager: WorkoutStorageManager?
}

extension WorkoutDetailInteractor: WorkoutDetailBusinessLogic, WorkoutDetailDataStore {
    
    func showWorkoutDetails(request: WorkoutDetailModel.GetWorkoutDetails.Request) {
        guard let workout = workout else {
            //TODO: - FIX  THIS with alerts
            presenter?.didFailPresentWorkoutDetails(withError: "workout details data did not passed")
            return
        }
        
        let response = WorkoutDetailModel.GetWorkoutDetails.Response(workout: workout)
        presenter?.presentWorkoutDetails(response: response)
    }
    
    func showWorkoutLicense(request: WorkoutDetailModel.GetLicense.Request) {
            let response = WorkoutDetailModel.GetLicense.Response()
            presenter?.presentWorkoutLicense(response: response)
    }
    
    func showSaveAlert(request: WorkoutDetailModel.ShowSaveAlert.Request) {
        presenter?.presentSaveAlert(response: WorkoutDetailModel.ShowSaveAlert.Response())
    }
}
