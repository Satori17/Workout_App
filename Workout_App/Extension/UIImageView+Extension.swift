//
//  UIImageViewExtensions.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    enum ImageKey {
        static let placeholder = "image_placeholder"
        static let cardio = "Cardio"
    }
    
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.sd_setImage(with: url)
        }
    }
    
    func getImage(from path: String) {
        let placeholder = ImageKey.placeholder
        guard path != placeholder else {
            self.image = UIImage(named: placeholder)
            self.contentMode = .scaleAspectFill
            return
        }
        
        self.loadFrom(URLAddress: path)
        self.contentMode = .scaleAspectFit
    }
}
