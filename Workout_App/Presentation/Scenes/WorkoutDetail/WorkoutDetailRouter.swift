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
    func routeToShowAlert(withTitle text: String, success: Bool)
}

protocol WorkoutDetailDataPassing {
    var dataStore: WorkoutDetailDataStore? { get }
}

final class WorkoutDetailRouter {
    
    //MARK: - Clean Components
    weak var viewController: WorkoutDetailViewController?
    var dataStore: WorkoutDetailDataStore?
}

extension WorkoutDetailRouter: WorkoutDetailRoutingLogic, WorkoutDetailDataPassing {
    
    //MARK: - Routing
    func routeToWorkoutLicense() {
        guard let licenseUrl = dataStore?.workout?.license.url  else {
            routeToShowAlert(withTitle: AlertKeys.licenseFailed, success: false)
            return }
        let safariVC = SFSafariViewController(url: licenseUrl)
        viewController?.present(safariVC, animated: true)
    }
    
    func routeToSaveAlert() {
        guard let workout = dataStore?.workout else { return }
        if let alertVC = UIStoryboard(name: Ids.alert, bundle: nil).instantiateViewController(withIdentifier: Ids.alert) as? AlertViewController {
            AlertConfigurator.configure(vc: alertVC, alertTitle: nil, success: false)
            if var alertDS = alertVC.router?.dataStore {
                if let chosenVariation = viewController?.contentView.chosenVariation {
                    passToSave(workout: chosenVariation, destination: &alertDS)
                } else {
                    passToSave(workout: workout, destination: &alertDS)
                }
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
    
    //MARK: - Passing data
    func passToSave(workout: Displayable, destination: inout AlertDataStore) {
        destination.workoutToSave = workout
    }
}
