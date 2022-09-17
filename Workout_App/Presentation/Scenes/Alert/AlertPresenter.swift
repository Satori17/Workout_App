//
//  AlertPresenter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

protocol AlertPresentationLogic {
    func presentWorkoutIntensityData(response: AlertModel.GetWorkoutIntensity.Response)
    func presentAlert(response: AlertModel.ShowAlert.Response)
}

final class AlertPresenter {
    
    //MARK: - Clean Components
    weak var viewController: AlertDisplayLogic?
}

extension AlertPresenter: AlertPresentationLogic {
    
    func presentWorkoutIntensityData(response: AlertModel.GetWorkoutIntensity.Response) {
        let viewModel = AlertModel.GetWorkoutIntensity.ViewModel(sets: response.intensityData.sets, reps: response.intensityData.reps, weekDays: response.intensityData.weekDays)
        viewController?.displayIntensityData(viewModel: viewModel)
    }
    
    func presentAlert(response: AlertModel.ShowAlert.Response) {
        let viewModel = AlertModel.ShowAlert.ViewModel(alertText: response.alertText, success: response.success)
        viewController?.displayAlert(viewModel: viewModel)
    }
}
