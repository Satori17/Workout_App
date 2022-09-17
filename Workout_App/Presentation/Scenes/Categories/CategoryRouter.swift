//
//  CategoryRouter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 30.07.22.
//

import UIKit

protocol CategoryRoutingLogic {
    func routeToWorkouts()
    func routeToShowAlert(withTitle text: String, success: Bool)
}

protocol CategoryDataPassing {
    var dataStore: CategoryDataStore? { get set }
}

final class CategoryRouter: CategoryDataPassing {
    
    //MARK: - Clean Components
    weak var viewController: UIViewController?
    var dataStore: CategoryDataStore?
}

extension CategoryRouter: CategoryRoutingLogic {
    
    func routeToWorkouts() {
        if let workoutsVC = UIStoryboard(name: Ids.workouts, bundle: nil).instantiateViewController(withIdentifier: Ids.workouts) as? WorkoutsViewController,
           let id = dataStore?.categoryId,
           let name = dataStore?.categoryName {
            workoutsVC.title = name
            WorkoutsConfigurator.configure(vc: workoutsVC, categoryId: id)
            viewController?.navigationController?.pushViewController(workoutsVC, animated: true)
        }               
    }
    
    func routeToShowAlert(withTitle text: String, success: Bool) {
        if let alertVC = UIStoryboard(name: Ids.alert, bundle: nil).instantiateViewController(withIdentifier: Ids.alert) as? AlertViewController {
            AlertConfigurator.configure(vc: alertVC, alertTitle: text, success: success)
            viewController?.present(alertVC, animated: true)
        }
    }
}
