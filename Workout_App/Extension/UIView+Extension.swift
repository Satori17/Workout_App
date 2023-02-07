//
//  UIView+Extension.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 03.08.22.
//

import UIKit

extension UIView {
    
    private func gradientForView(with gradientMask: CAGradientLayer, firstColor: UIColor, secondColor: UIColor) {
        gradientMask.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientMask.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientMask.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientMask.locations = [0.0, 0.7]
        gradientMask.frame = bounds
        self.layer.insertSublayer(gradientMask, at: 0)
    }
    
    func gradientForImageView(gradient: CAGradientLayer) {
        gradient.colors = [
            UIColor.Gradient.skyBlueOption.cgColor,
            UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.locations = [0.0, 0.7]
        gradient.frame = bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addShadow(ofRadius radius: Double) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 1
    }
    
    func maskCurved(highly: Bool, corner: CACornerMask = [.bottomLeft, .bottomRight, .topLeft, .topRight]) {
        self.layer.cornerRadius = highly ? 15 : 7
        self.layer.maskedCorners = [corner]
    }
    
    //MARK: - Main method of app design
    func withAppDesign(layer: CAGradientLayer, color: UIColor = UIColor.Gradient.lightGrayOption, curvedCorners: Bool) {
        self.layer.cornerRadius = curvedCorners ? 25 : 0
        self.layer.borderWidth = curvedCorners ? 1 : 0
        self.layer.borderColor = UIColor.Gradient.lightGrayOption.cgColor
        self.gradientForView(with: layer, firstColor: UIColor.Gradient.skyBlueOption, secondColor: color)
    }
}
