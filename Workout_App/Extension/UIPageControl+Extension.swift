//
//  UIPageControl+Extension.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

extension UIPageControl {
    var page: Int {
        get {
            currentPage
        }
        set {
            currentPage = newValue
        }
    }
}
