//
//  MaskedCornerKeys.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 10.09.22.
//

import UIKit

extension CACornerMask {
    static let bottomLeft = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
    static let topLeft = CACornerMask.layerMinXMinYCorner
    static let topRight = CACornerMask.layerMaxXMinYCorner
}
