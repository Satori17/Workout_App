//
//  AlertRouter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

protocol AlertDataPassing {
    var dataStore: AlertDataStore? { get }
}

final class AlertRouter: AlertDataPassing {
    //MARK: - Clean Components
    weak var viewController: AlertViewController?
    
    //MARK: - DataStore
    var dataStore: AlertDataStore?
}
