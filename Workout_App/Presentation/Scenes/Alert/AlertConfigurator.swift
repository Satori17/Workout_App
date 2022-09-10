//
//  AlertConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

final class AlertConfigurator {

    static func configure(vc: AlertViewController) {
        //interactor
        let interactor = AlertInteractor()
        vc.interactor = interactor
        //presenter
        let presenter = AlertPresenter()
        presenter.viewController = vc
        interactor.presenter = presenter
        //router
        let router = AlertRouter()
        vc.router = router
        router.viewController = vc
        //dataStore
        router.dataStore = interactor
        //worker
        let worker = AlertWorker()
        interactor.worker = worker
        //storage manager
        let storageManager = WorkoutStorageManager()
        interactor.storageManager = storageManager
    }
}
