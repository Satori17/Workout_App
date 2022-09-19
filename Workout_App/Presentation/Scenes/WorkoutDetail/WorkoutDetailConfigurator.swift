//
//  WorkoutDetailConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit

final class WorkoutDetailConfigurator {
    
    static func configure(vc: WorkoutDetailViewController, isSaved: Bool) {
        //MARK: - Interactor
        let interactor = WorkoutDetailInteractor(isSaved: isSaved)
        vc.interactor = interactor
        
        //MARK: - Presenter
        let presenter = WorkoutDetailPresenter()
        presenter.viewController = vc
        interactor.presenter = presenter
        
        //MARK: - Router
        let router = WorkoutDetailRouter()
        vc.router = router
        router.viewController = vc
        
        //MARK: - DataStore
        router.dataStore = interactor
    }
}
