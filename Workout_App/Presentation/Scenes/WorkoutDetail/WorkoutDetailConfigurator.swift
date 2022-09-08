//
//  WorkoutDetailConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit

class WorkoutDetailConfigurator {

    static func configure(vc: WorkoutDetailViewController) {
        //interactor
        let interactor = WorkoutDetailInteractor()
        vc.interactor = interactor
        //presenter
        let presenter = WorkoutDetailPresenter()
        presenter.viewController = vc
        interactor.presenter = presenter
        //router
        let router = WorkoutDetailRouter()
        vc.router = router
        router.viewController = vc
        //dataStore
        router.dataStore = interactor
        //storage manager
        let storageManager = WorkoutStorageManager()
        interactor.storageManager = storageManager
    }
}
