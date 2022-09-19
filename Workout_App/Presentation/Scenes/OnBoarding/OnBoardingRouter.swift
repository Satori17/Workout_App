//
//  OnBoardingRouter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

protocol OnBoardingRoutingLogic {
    func routeToMainTabBar()
}

final class OnBoardingRouter {
    
    //MARK: - Clean Components
    weak var viewController: OnBoardingViewController?
}

extension OnBoardingRouter: OnBoardingRoutingLogic {
    
    //MARK: - Routing
    func routeToMainTabBar() {
        let mainTabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Ids.tabBar)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBar)
    }
}
