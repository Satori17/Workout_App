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
    func presentRepRangeAlert(response: AlertModel.ShowRepRangeAlert.Response)
}

final class AlertPresenter {
    
    //MARK: - Clean Components
    weak var viewController: AlertDisplayLogic?
}

//MARK: - Presentation Logic protocol
extension AlertPresenter: AlertPresentationLogic {
    
    func presentWorkoutIntensityData(response: AlertModel.GetWorkoutIntensity.Response) {
        let viewModel = AlertModel.GetWorkoutIntensity.ViewModel(sets: response.intensityData.sets, reps: response.intensityData.reps, weekDays: response.intensityData.weekDays)
        viewController?.displayIntensityData(viewModel: viewModel)
    }
    
    func presentAlert(response: AlertModel.ShowAlert.Response) {
        let viewModel = AlertModel.ShowAlert.ViewModel(alertText: response.alertText, success: response.success)
        viewController?.displayAlert(viewModel: viewModel)
    }
    
    func presentRepRangeAlert(response: AlertModel.ShowRepRangeAlert.Response) {
        let viewModel = AlertModel.ShowRepRangeAlert.ViewModel(text: response.text, textColor: response.textColor)
        viewController?.displayRepRangeAlert(viewModel: viewModel)        
    }
}
