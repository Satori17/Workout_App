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
    
    //MARK: - DataStore Properties
    var workout: Displayable?
    
    //MARK: - Properties
    var isSaved: Bool = false
    
    init(isSaved: Bool) {
        self.isSaved = isSaved
    }
}

extension WorkoutDetailInteractor: WorkoutDetailBusinessLogic, WorkoutDetailDataStore {
    
    func showWorkoutDetails(request: WorkoutDetailModel.GetWorkoutDetails.Request) {
        guard let workout = workout else {
            presenter?.didFailPresentWorkoutDetails(withError: AlertKeys.dataPassFailed)
            return
        }
        
        let response = WorkoutDetailModel.GetWorkoutDetails.Response(workout: workout, isSaved: isSaved)
        presenter?.presentWorkoutDetails(response: response)
    }
    
    func showWorkoutLicense(request: WorkoutDetailModel.GetLicense.Request) {
        presenter?.presentWorkoutLicense(response: WorkoutDetailModel.GetLicense.Response())
    }
    
    func showSaveAlert(request: WorkoutDetailModel.ShowSaveAlert.Request) {
        presenter?.presentSaveAlert(response: WorkoutDetailModel.ShowSaveAlert.Response())
    }
}
