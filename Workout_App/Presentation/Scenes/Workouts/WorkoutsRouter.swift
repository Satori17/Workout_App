//
//  WorkoutsRouter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

protocol WorkoutsRoutingLogic {
    func instantiateDetailsVC(withWorkout workout: WorkoutViewModel) -> WorkoutDetailViewController
    func passDetailsData(ofWorkout workout: WorkoutViewModel, destination: inout WorkoutDetailDataStore)
    func routeToWorkoutDetails()
    func routeToSaveAlert()
    func routeToShowAlert(withTitle text: String, success: Bool)
}

protocol WorkoutsDataPassing {
    var dataStore: WorkoutsDataStore? { get set }
}

final class WorkoutsRouter: WorkoutsDataPassing {
    
    //MARK: - Clean Components
    weak var viewController: WorkoutsViewController?
    var dataStore: WorkoutsDataStore?
}

extension WorkoutsRouter: WorkoutsRoutingLogic {
    
    //MARK: - Routing
    func routeToWorkoutDetails() {
        guard let workout = dataStore?.selectedWorkout, let animated = dataStore?.isTransitionAnimated else { return }
        let detailsVC = instantiateDetailsVC(withWorkout: workout)
        detailsVC.isSaved = false
        viewController?.navigationController?.pushViewController(detailsVC, animated: animated)
    }
    
    func routeToSaveAlert() {
        guard let workout = dataStore?.selectedWorkout else { return }
        if let alertVC = UIStoryboard(name: Ids.alert, bundle: nil).instantiateViewController(withIdentifier: Ids.alert) as? AlertViewController {
            AlertConfigurator.configure(vc: alertVC, alertTitle: nil, success: false)
            if var alertDS = alertVC.router?.dataStore {
                passToSave(workout: workout, destination: &alertDS)
            }            
            viewController?.present(alertVC, animated: true)
        }
    }
    
    func routeToShowAlert(withTitle text: String, success: Bool) {
        if let alertVC = UIStoryboard(name: Ids.alert, bundle: nil).instantiateViewController(withIdentifier: Ids.alert) as? AlertViewController {
            AlertConfigurator.configure(vc: alertVC, alertTitle: text, success: success)
            viewController?.present(alertVC, animated: true)
        }
    }
    
    // MARK: Passing data
    func passDetailsData(ofWorkout workout: WorkoutViewModel, destination: inout WorkoutDetailDataStore) {
        destination.workout = workout
    }
    
    func passToSave(workout: WorkoutViewModel, destination: inout AlertDataStore) {
        destination.workoutToSave = workout
    }
    
    //MARK: - Instantiate
    func instantiateDetailsVC(withWorkout workout: WorkoutViewModel) -> WorkoutDetailViewController {
        if let workoutDetailVC = UIStoryboard(name: Ids.workoutDetail, bundle: nil).instantiateViewController(withIdentifier: Ids.workoutDetail) as? WorkoutDetailViewController {
            WorkoutDetailConfigurator.configure(vc: workoutDetailVC)
            workoutDetailVC.isSaved = true
            if var workoutDetailDS = workoutDetailVC.router?.dataStore {
                passDetailsData(ofWorkout: workout, destination: &workoutDetailDS)
            }
            
            return workoutDetailVC
        }
        return WorkoutDetailViewController()
    }
}
