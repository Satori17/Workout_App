//
//  AlertInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

protocol AlertBusinessLogic {
    func saveWorkout(request: AlertModel.SaveWorkout.Request)
    func showAlert(request: AlertModel.ShowAlert.Request)
    func showRepRangeAlert(request: AlertModel.ShowRepRangeAlert.Request)
}

protocol AlertDataStore {
    var workoutToSave: Displayable? { get set }
}

final class AlertInteractor: AlertDataStore {
    
    //MARK: - Clean Components
    var presenter: AlertPresentationLogic?
    var worker: alertWorkerLogic?
    
    //MARK: - DataStore Properties
    var workoutToSave: Displayable?
    
    //MARK: - Properties
    var alertText: String?
    var success: Bool = false
    
    init(alertText: String?, success: Bool) {
        self.alertText = alertText
        self.success = success
    }
}

//MARK: - Business Logic protocol
extension AlertInteractor: AlertBusinessLogic {
    
    func saveWorkout(request: AlertModel.SaveWorkout.Request) {
        guard let workout = workoutToSave else { return }
        worker?.saveWorkoutToStorage(model: workout, sets: request.sets, reps: request.reps, weekDay: request.weekDay, completion: { error in
            let response = AlertModel.ShowAlert.Response(alertText: error.rawValue, success: false)
            presenter?.presentAlert(response: response)
        })
    }
    
    func showAlert(request: AlertModel.ShowAlert.Request) {
        if let alertText = alertText {
            let response = AlertModel.ShowAlert.Response(alertText: alertText, success: success)
            presenter?.presentAlert(response: response)
        } else {
            let intensityData = worker?.fetchWorkoutIntensityData()
            if let intensityData = intensityData {
                let response = AlertModel.GetWorkoutIntensity.Response(intensityData: intensityData)
                presenter?.presentWorkoutIntensityData(response: response)
            }
        }
    }
    
    func showRepRangeAlert(request: AlertModel.ShowRepRangeAlert.Request) {
        let response = request.repCount >= 5 ? AlertModel.ShowRepRangeAlert.Response(text: SaveTitle.initialText, textColor: SaveTitle.initialColor) : AlertModel.ShowRepRangeAlert.Response(text: SaveTitle.alertText, textColor: SaveTitle.alertColor)
        presenter?.presentRepRangeAlert(response: response)
    }
}
