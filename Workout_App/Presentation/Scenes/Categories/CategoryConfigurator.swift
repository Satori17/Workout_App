//
//  CategoryConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit

final class CategoryConfigurator {
    
    static func configure(vc: CategoryViewController) {
        //MARK: - Interactor
        let interactor = CategoryInteractor()
        vc.interactor = interactor
        
        //MARK: - Presenter
        let presenter = CategoryPresenter()
        interactor.presenter = presenter
        presenter.viewController = vc
        
        //MARK: - Router
        let router = CategoryRouter()
        vc.router = router
        router.viewController = vc
        
        //MARK: - DataStore
        router.dataStore = interactor
        
        //MARK: - Worker
        let worker = CategoryWorker()
        interactor.worker = worker
    }
}
