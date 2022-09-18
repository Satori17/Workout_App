//
//  OnBoardingConfigurator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

final class OnBoardingConfigurator {
    
    static func configure(vc: OnBoardingViewController) {
        //MARK: - Interactor
        let interactor = OnBoardingInteractor()
        vc.interactor = interactor
        
        //MARK: - Presenter
        let presenter = OnBoardingPresenter()
        presenter.viewController = vc
        interactor.presenter = presenter
        
        //MARK: - Router
        let router = OnBoardingRouter()
        vc.router = router
        router.viewController = vc
        
        //MARK: - DataStore
        router.dataStore = interactor
        
        //MARK: - Worker
        let worker = OnBoardingWorker()
        interactor.worker = worker
    }
}
