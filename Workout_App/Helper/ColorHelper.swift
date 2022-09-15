//
//  ColorHelper.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 10.09.22.
//

import UIKit

extension UIColor {
    enum ColorKey {
        static let skyBlue = UIColor(named: "GradientColor1")
        static let lightGray = UIColor(named: "GradientColor2")
        static let adaptive = UIColor(named: "AdaptiveColor")
    }
    
  enum Gradient {
      //MARK: - Gray
    static var lightGrayOption: UIColor {
        if let lightGrayColor = UIColor.ColorKey.lightGray?.withAlphaComponent(0.3) {
            return lightGrayColor
        }
        return UIColor.clear
    }
      
      //MARK: - SkyBlue
      static var skyBlueOption: UIColor {
          if let skyBlueColor = UIColor.ColorKey.skyBlue?.withAlphaComponent(0.5) {
              return skyBlueColor
          }
          return UIColor.clear
      }
      
      //MARK: - White
    static var whiteOption: UIColor {
        return UIColor.white
    }
  }
}
