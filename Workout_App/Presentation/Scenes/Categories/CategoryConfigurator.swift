//
//  CategoryConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit

class CategoryConfigurator {
    
    static func configure(vc: CategoryViewController) {
        //interactor
        let interactor = CategoryInteractor()
        vc.interactor = interactor
        
        //presenter
        let presenter = CategoryPresenter()
        interactor.presenter = presenter
        presenter.viewController = vc
        
        //router
        let router = CategoryRouter()
        vc.router = router
        router.viewController = vc
        
        //title
        vc.title = "Workouts"
    }
}
