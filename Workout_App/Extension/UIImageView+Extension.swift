//
//  UIImageViewExtensions.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.sd_setImage(with: url)
        }
    }
    
    func getImage(from path: String) {
        let placeholder = "image_placeholder"
        guard path != placeholder else {
            self.image = UIImage(named: placeholder)
            self.contentMode = UIDevice.current.orientation.isLandscape ? .scaleAspectFit : .scaleAspectFill
            return
        }
        
        self.loadFrom(URLAddress: path)
        self.contentMode = .scaleAspectFit
    }
}
