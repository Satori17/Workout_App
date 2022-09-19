//
//  AlertConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

final class AlertConfigurator {
    
    static func configure(vc: AlertViewController, alertTitle text: String?, success: Bool) {
        //MARK: - Interactor
        let interactor = AlertInteractor(alertText: text, success: success)
        vc.interactor = interactor
        
        //MARK: - Presenter
        let presenter = AlertPresenter()
        presenter.viewController = vc
        interactor.presenter = presenter
        
        //MARK: - Router
        let router = AlertRouter()
        vc.router = router
        router.viewController = vc
        
        //MARK: - DataStore
        router.dataStore = interactor
        
        //MARK: - Storage Manager
        let storageManager = WorkoutStorageManager()
        
        //MARK: - Worker
        let worker = AlertWorker(storageManager: storageManager)
        interactor.worker = worker
    }
}
