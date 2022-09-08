//
//  UIColor+Extension.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit

extension UIColor {
    
    enum GradientColor: String {
        case skyBlue = "GradientColor1"
        case lightGray = "GradientColor2"
    }
    
    
  struct Gradient {
      
      //gray
    static var lightGrayOption: UIColor {
        if let lightGrayColor = UIColor(named: GradientColor.lightGray.rawValue)?.withAlphaComponent(0.3) {
            return lightGrayColor
        }
        return UIColor.clear
    }
      
      //skyBlue
      static var skyBlueOption: UIColor {
          if let skyBlueColor = UIColor(named: GradientColor.skyBlue.rawValue)?.withAlphaComponent(0.5) {
              return skyBlueColor
          }
          return UIColor.clear
      }
      
      //white
    static var whiteOption: UIColor {
        return UIColor.white
    }
  }    
}
