//
//  WorkoutsConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

final class WorkoutsConfigurator {

    static func configure(vc: WorkoutsViewController, categoryId: Int) {
        //interactor
        let interactor = WorkoutsInteractor(categoryId: categoryId)
        vc.interactor = interactor
        //presenter
        let presenter = WorkoutsPresenter()
        presenter.viewController = vc
        interactor.presenter = presenter
        //router
        let router = WorkoutsRouter()
        vc.router = router
        router.viewController = vc
        //dataStore
        router.dataStore = interactor
        //worker
        let worker = WorkoutsWorker()
        interactor.worker = worker
    }
}
