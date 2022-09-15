//
//  HomeRouter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomeRoutingLogic {
    func instantiateDetailsVC(withWorkout workout: CoreWorkoutViewModel) -> WorkoutDetailViewController
    func passDetailsData(ofWorkout workout: CoreWorkoutViewModel, destination: inout WorkoutDetailDataStore)
    func routeToWorkoutDetails()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

final class HomeRouter: HomeDataPassing {
    
    //MARK: - Clean Components
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
}

extension HomeRouter: HomeRoutingLogic {
    
    //MARK: - Routing
    func routeToWorkoutDetails() {
        guard let savedWorkout = dataStore?.selectedSavedWorkout else { return }
        let detailsVC = instantiateDetailsVC(withWorkout: savedWorkout)
        detailsVC.sheetPresentationController?.detents = [.medium(), .large()]
        detailsVC.isSaved = true
        viewController?.present(detailsVC, animated: true)
    }
    
    // MARK: Passing data
    func passDetailsData(ofWorkout workout: CoreWorkoutViewModel, destination: inout WorkoutDetailDataStore) {
        destination.workout = workout
    }
    
    //MARK: - Instantiate
    func instantiateDetailsVC(withWorkout workout: CoreWorkoutViewModel) -> WorkoutDetailViewController {
        if let workoutDetailVC = UIStoryboard(name: Ids.workoutDetail, bundle: nil).instantiateViewController(withIdentifier: Ids.workoutDetail) as? WorkoutDetailViewController {
            WorkoutDetailConfigurator.configure(vc: workoutDetailVC)
            if var workoutDetailDS = workoutDetailVC.router?.dataStore {
                passDetailsData(ofWorkout: workout, destination: &workoutDetailDS)
            }
            
            return workoutDetailVC
        }
        return WorkoutDetailViewController()
    }
}
