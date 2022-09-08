//
//  HomeConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

class HomeConfigurator {
    
    static func configure(vc: HomeViewController) {
        //interactor
        let interactor = HomeInteractor()
        vc.interactor = interactor
        //presenter
        let presenter = HomePresenter()
        presenter.viewController = vc
        interactor.presenter = presenter        
        //router
        let router = HomeRouter()
        vc.router = router
        router.viewController = vc
        //dataStore
        router.dataStore = interactor
        //storage manager
        let storageManager = WorkoutStorageManager()
        //worker
        let worker = HomeWorker(storageManager: storageManager)
        interactor.worker = worker
        interactor.storageManager = storageManager
    }
}
