//
//  UIImage+Extension.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

extension UIImage {
    
    func resizeImage(targetSize: CGFloat) -> UIImage? {
        let scale = targetSize / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: targetSize))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
