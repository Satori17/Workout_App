//
//  WorkoutsConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

final class WorkoutsConfigurator {
    
    static func configure(vc: WorkoutsViewController, categoryId: Int) {
        //MARK: - Interactor
        let interactor = WorkoutsInteractor(categoryId: categoryId)
        vc.interactor = interactor
        
        //MARK: - Presenter
        let presenter = WorkoutsPresenter()
        presenter.viewController = vc
        interactor.presenter = presenter
        
        //MARK: - Router
        let router = WorkoutsRouter()
        vc.router = router
        router.viewController = vc
        
        //MARK: - DataStore
        router.dataStore = interactor
        
        //MARK: - Worker
        let worker = WorkoutsWorker()
        interactor.worker = worker
        
        //MARK: - Activity Indicator
        let activityIndicator = ActivityIndicatorManager(vc)
        vc.activityIndicator = activityIndicator
        
    }
}
