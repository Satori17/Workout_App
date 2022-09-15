//
//  WorkoutDetailPresenter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit

protocol WorkoutDetailPresentationLogic {
    func presentWorkoutDetails(response: WorkoutDetailModel.GetWorkoutDetails.Response)
    func didFailPresentWorkoutDetails(withError message: String)
    func presentWorkoutLicense(response: WorkoutDetailModel.GetLicense.Response)
    func presentSaveAlert(response: WorkoutDetailModel.ShowSaveAlert.Response)
}

final class WorkoutDetailPresenter {
    
    //MARK: - Clean Components
    weak var viewController: WorkoutDetailDisplayLogic?
}

extension WorkoutDetailPresenter: WorkoutDetailPresentationLogic {
        
    func presentWorkoutDetails(response: WorkoutDetailModel.GetWorkoutDetails.Response) {
        let viewModel = WorkoutDetailModel.GetWorkoutDetails.ViewModel(workout: response.workout)
        viewController?.displayWorkoutDetails(viewModel: viewModel)
    }
    
    func didFailPresentWorkoutDetails(withError message: String) {
        viewController?.didFailDisplayWorkoutDetails(withError: message)
    }
    
    func presentWorkoutLicense(response: WorkoutDetailModel.GetLicense.Response) {
        let viewModel = WorkoutDetailModel.GetLicense.ViewModel()
        viewController?.displayWorkoutLicense(viewModel: viewModel)
    }
    
    func presentSaveAlert(response: WorkoutDetailModel.ShowSaveAlert.Response) {
        viewController?.displaySaveAlert(viewModel: WorkoutDetailModel.ShowSaveAlert.ViewModel())
    }
}
