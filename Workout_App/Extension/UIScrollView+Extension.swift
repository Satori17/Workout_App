//
//  UIScrollView+Extension.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 03.09.22.
//

import UIKit

extension UIScrollView {

    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
}
