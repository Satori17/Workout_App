//
//  OnBoardingInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

protocol OnBoardingBusinessLogic {
    func getOnBoardingScreens(request: OnBoarding.getScreen.Request)
    func showMainTabBar(request: OnBoarding.ShowMainTabBar.Request)
}

final class OnBoardingInteractor {
    
    //MARK: - Clean Components
    var presenter: OnBoardingPresentationLogic?
    var worker: OnBoardingWorkerLogic?
}

//MARK: - Business Logic protocol
extension OnBoardingInteractor: OnBoardingBusinessLogic {
    
    func getOnBoardingScreens(request: OnBoarding.getScreen.Request) {
        guard let onBoardingScreens = worker?.fetchOnBoardingScreens() else { return }
        let response = OnBoarding.getScreen.Response(screens: onBoardingScreens)
        presenter?.presentOnBoardingScreens(response: response)
    }
    
    func showMainTabBar(request: OnBoarding.ShowMainTabBar.Request) {
        presenter?.presentMainTabBar(response: OnBoarding.ShowMainTabBar.Response())
    }
}
