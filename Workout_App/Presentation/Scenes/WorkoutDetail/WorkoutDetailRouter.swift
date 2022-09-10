//
//  WorkoutDetailRouter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit
import SafariServices

protocol WorkoutDetailRoutingLogic {
    func routeToWorkoutLicense()
    func routeToSaveAlert()
}

protocol WorkoutDetailDataPassing {
  var dataStore: WorkoutDetailDataStore? { get }
    
}

final class WorkoutDetailRouter {
    //clean components
  weak var viewController: WorkoutDetailViewController?
  var dataStore: WorkoutDetailDataStore?
  
}

extension WorkoutDetailRouter: WorkoutDetailRoutingLogic, WorkoutDetailDataPassing {
    
    //MARK: - Routing
    
    func routeToWorkoutLicense() {
        guard let licenseUrl = dataStore?.workout?.license.url  else {
            viewController?.didFailDisplayWorkoutLicense(withError: "License Couldn't be loaded")
            return }
        let safariVC = SFSafariViewController(url: licenseUrl)
        viewController?.present(safariVC, animated: true)
    }
    
    func routeToSaveAlert() {
        guard let workout = dataStore?.workout else { return }
        if let alertVC = UIStoryboard(name: Ids.alert, bundle: nil).instantiateViewController(withIdentifier: Ids.alert) as? AlertViewController {
            AlertConfigurator.configure(vc: alertVC)
            if var alertDS = alertVC.router?.dataStore {
                passToSave(workout: workout, destination: &alertDS)
            }
            viewController?.present(alertVC, animated: true)
        }
    }
    
    //MARK: - Passing data
    
    func passToSave(workout: Displayable, destination: inout AlertDataStore) {
        destination.workoutToSave = workout
    }
}
