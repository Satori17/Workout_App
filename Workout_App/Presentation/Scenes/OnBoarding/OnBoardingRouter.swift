//
//  OnBoardingRouter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

protocol OnBoardingRoutingLogic {
    func routeToHomeScreen()
}

protocol OnBoardingDataPassing {
    var dataStore: OnBoardingDataStore? { get }
}

final class OnBoardingRouter {
    
    //MARK: - Clean Components
    weak var viewController: OnBoardingViewController?
    
    //MARK: - DataStore
    var dataStore: OnBoardingDataStore?
}

extension OnBoardingRouter: OnBoardingRoutingLogic, OnBoardingDataPassing {
    
    //MARK: - Routing
    func routeToHomeScreen() {
        
    }
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: OnBoardingViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: OnBoardingDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
    
}
