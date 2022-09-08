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
        layer.insertSublayer(gradientMask, at: 0)
    }
    
    func withAppDesign(layer: CAGradientLayer, color: UIColor = UIColor.Gradient.lightGrayOption, curvedCorners: Bool) {        
        self.layer.cornerRadius = curvedCorners ? 25 : 0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.Gradient.lightGrayOption.cgColor
        //setting gradient
        self.gradientForView(with: layer, firstColor: UIColor.Gradient.skyBlueOption, secondColor: color)
    }
    
    func addShadow(ofRadius radius: Double) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 1
    }
    
    func maskCurved(corner: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]) {
        self.layer.cornerRadius = 7
        self.layer.maskedCorners = [corner]
    }
}

//corner mask for UIView
extension CACornerMask {
    static let bottomLeft = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
    static let topLeft = CACornerMask.layerMinXMinYCorner
    static let topRight = CACornerMask.layerMaxXMinYCorner   
}
