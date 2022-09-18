//
//  OnBoardingInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

protocol OnBoardingBusinessLogic {
    func getOnBoardingScreens(request: OnBoarding.getScreen.Request)
}

protocol OnBoardingDataStore {
}

final class OnBoardingInteractor {
    
    //MARK: - Clean Components
    var presenter: OnBoardingPresentationLogic?
    var worker: OnBoardingWorkerLogic?
}

extension OnBoardingInteractor: OnBoardingBusinessLogic, OnBoardingDataStore {
    
    func getOnBoardingScreens(request: OnBoarding.getScreen.Request) {
        guard let onBoardingScreens = worker?.fetchOnBoardingScreens() else { return }
        let response = OnBoarding.getScreen.Response(screens: onBoardingScreens)
        presenter?.presentOnBoardingScreens(response: response)
    }
}
