//
//  OnBoardingWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

protocol OnBoardingWorkerLogic {
    func fetchOnBoardingScreens() -> [OnBoardingModel]
}

final class OnBoardingWorker {
    
    //MARK: - Properties
    private let screensData: [OnBoardingModel] = [
        OnBoardingModel(
            title: LottieKeys.workoutIcon.title,
            animatedImage: LottieKeys.workoutIcon.image
        ),
        OnBoardingModel(
            title: LottieKeys.foodIcon.title,
            animatedImage: LottieKeys.foodIcon.image
        ),
        OnBoardingModel(
            title: LottieKeys.waterBottleIcon.title,
            animatedImage: LottieKeys.waterBottleIcon.image
        ),
        OnBoardingModel(
            title: LottieKeys.meditationIcon.title,
            animatedImage: LottieKeys.meditationIcon.image
        ),
        OnBoardingModel(
            title: LottieKeys.dumbellIcon.title,
            animatedImage: LottieKeys.dumbellIcon.image
        )
    ]
}

extension OnBoardingWorker: OnBoardingWorkerLogic {
    
    func fetchOnBoardingScreens() -> [OnBoardingModel] {
        screensData
    }
}
