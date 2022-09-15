//
//  AlertPresenter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

protocol AlertPresentationLogic {
    func presentWorkoutIntensityData(response: Alert.GetWorkoutIntensity.Response)
}

final class AlertPresenter {
    
    //MARK: - Clean Components
    weak var viewController: AlertDisplayLogic?
}

extension AlertPresenter: AlertPresentationLogic {
    
    func presentWorkoutIntensityData(response: Alert.GetWorkoutIntensity.Response) {
        let viewModel = Alert.GetWorkoutIntensity.ViewModel(sets: response.intensityData.sets, reps: response.intensityData.reps, weekDays: response.intensityData.weekDays)
        viewController?.displayIntensityData(viewModel: viewModel)
    }
}
