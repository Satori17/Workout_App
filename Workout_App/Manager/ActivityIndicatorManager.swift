//
//  ActivityIndicator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit


class ActivityIndicatorManager {
    
    static let shared = ActivityIndicatorManager()
    
    private let activityIndicator = UIActivityIndicatorView()
    private var effectView = UIVisualEffectView()
    private let backgroundView = UIView()
    private let gradientMaskLayer = CAGradientLayer()
    
    
    func setupActivityIndicator(_ vc: UIViewController) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center = vc.view.center
        let backgroundView = backgroundView(vc: vc)
        backgroundView.addSubview(setupEffectView())
        backgroundView.addSubview(activityIndicator)
        vc.view.addSubview(backgroundView)
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        backgroundView.isHidden = true
        
    }
    
    private func backgroundView(vc: UIViewController) -> UIView {
        backgroundView.isHidden = false
        backgroundView.frame = vc.view.frame
        backgroundView.withAppDesign(layer: gradientMaskLayer)

        return backgroundView
    }
    
    private func setupEffectView() -> UIVisualEffectView {
        let effect: UIBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        return effectView
    }
}
