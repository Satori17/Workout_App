//
//  AlertInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//


import UIKit

protocol AlertBusinessLogic {
    func getWorkoutIntensityData(request: Alert.GetWorkoutIntensity.Request)
    func saveWorkout(request: Alert.SaveWorkout.Request)
}

protocol AlertDataStore {
    var workoutToSave: Displayable? { get set }
}

class AlertInteractor: AlertDataStore {
    //clean components
    var presenter: AlertPresentationLogic?
    var worker: AlertWorker?
    var workoutToSave: Displayable?
    //storage manager
    var storageManager: WorkoutStorageManager?
    
}

extension AlertInteractor: AlertBusinessLogic {
    
    func getWorkoutIntensityData(request: Alert.GetWorkoutIntensity.Request) {
        let intensityData = worker?.fetchWorkoutIntensityData()
        if let intensityData = intensityData {
            let response = Alert.GetWorkoutIntensity.Response(intensityData: intensityData)
            presenter?.presentWorkoutIntensityData(response: response)
        }
    }
    
    func saveWorkout(request: Alert.SaveWorkout.Request) {
        guard let workout = workoutToSave else { return }
        do {
            let _ = try storageManager?.addWorkout(fromModel: workout, sets: request.sets, reps: request.reps, weekDay: request.weekDay)
            print("workout is saved!")
        } catch {
            //TODO: - FIX THIS with alers
            print(StorageManagerError.addFailed)
        }
    }
    
}
