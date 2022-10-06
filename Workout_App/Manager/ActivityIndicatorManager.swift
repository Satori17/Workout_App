//
//  ActivityIndicator.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit

protocol activityIndicatorLogic {
    func startAnimating()
    func stopAnimating()
}

final class ActivityIndicatorManager {
    
    //MARK: - Properties
    private let activityIndicator = UIActivityIndicatorView()
    private var effectView = UIVisualEffectView()
    private let backgroundView = UIView()
    private let gradientMaskLayer = CAGradientLayer()
    
    init(_ vc: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.hidesWhenStopped = true
            self?.activityIndicator.style = UIActivityIndicatorView.Style.large
            self?.activityIndicator.center = vc.view.center
            guard let backgroundView = self?.backgroundView(vc: vc),
                  let effectView = self?.setupEffectView(),
                  let activityIndicator = self?.activityIndicator else { return }
            backgroundView.addSubview(effectView)
            backgroundView.addSubview(activityIndicator)
            vc.view.addSubview(backgroundView)
        }
    }
    
    //MARK: - Setup Methods
    private func backgroundView(vc: UIViewController) -> UIView {
        backgroundView.isHidden = false
        backgroundView.frame = vc.view.frame
        backgroundView.withAppDesign(layer: gradientMaskLayer, curvedCorners: true)
        
        return backgroundView
    }
    
    private func setupEffectView() -> UIVisualEffectView {
        let effect: UIBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        return effectView
    }
}

//MARK: - Activity Indicator Logic
extension ActivityIndicatorManager: activityIndicatorLogic {
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        backgroundView.isHidden = true
    }
}
