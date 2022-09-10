//
//  AlertRouter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

protocol AlertRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AlertDataPassing {
    var dataStore: AlertDataStore? { get }
}

final class AlertRouter {
    weak var viewController: AlertViewController?
    var dataStore: AlertDataStore?
    
}

extension AlertRouter: AlertRoutingLogic, AlertDataPassing {
    
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
    
    //func navigateToSomewhere(source: AlertViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: AlertDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
    
}
