//
//  OnBoardingModels.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

enum OnBoarding {
    
    // MARK: Get Screen Use Case
    enum getScreen {
        
        struct Request { }
        
        struct Response {
            let screens: [OnBoardingModel]
        }
        
        struct ViewModel {
            let screens: [OnBoardingModel]
        }
    }
    
    //MARK: - Show Main Tab Bar Use Case
    enum ShowMainTabBar {
        
        struct Request { }
        
        struct Response { }
        
        struct ViewModel { }
    }
}
