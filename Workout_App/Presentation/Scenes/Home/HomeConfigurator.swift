//
//  HomeConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

final class HomeConfigurator {
    
    static func configure(vc: HomeViewController) {
        //MARK: - Interactor
        let interactor = HomeInteractor()
        vc.interactor = interactor
        
        //MARK: - Presenter
        let presenter = HomePresenter()
        presenter.viewController = vc
        interactor.presenter = presenter
        
        //MARK: - Router
        let router = HomeRouter()
        vc.router = router
        router.viewController = vc
        
        //MARK: - DataStore
        router.dataStore = interactor
        
        //MARK: - Storage Manager
        let storageManager = WorkoutStorageManager()
        
        //MARK: - Worker
        let worker = HomeWorker(storageManager: storageManager)
        interactor.worker = worker
        
        //MARK: - Notification Manager
        let notificationManager = NotificationManager()
        vc.notificationManager = notificationManager
    }
}
