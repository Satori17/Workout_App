//
//  ActivityIndicator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit


class ActivityIndicator {
    
    static let shared = ActivityIndicator()
    let activityIndicator = UIActivityIndicatorView()
    
    func setupActivityIndicator(_ vc: UIViewController) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center = vc.view.center
        vc.view.addSubview(activityIndicator)
        
    }
}
