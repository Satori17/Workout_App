//
//  OnBoardingPresenter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

protocol OnBoardingPresentationLogic {
    func presentOnBoardingScreens(response: OnBoarding.getScreen.Response)
}

final class OnBoardingPresenter {
    
    //MARK: - Clean Components
    weak var viewController: OnBoardingDisplayLogic?
}

extension OnBoardingPresenter: OnBoardingPresentationLogic {
    
    func presentOnBoardingScreens(response: OnBoarding.getScreen.Response) {
        let viewModel = OnBoarding.getScreen.ViewModel(screens: response.screens)
        viewController?.displayOnBoardingScreens(viewModel: viewModel)
    }
}
