//
//  UICollectionView+Extension.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 06.08.22.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String { String(describing: self) }
    static var nibFile: UINib { UINib(nibName: identifier, bundle: nil) }
}

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(class: T.Type) {
        self.register(T.nibFile, forCellWithReuseIdentifier: T.identifier)
    }
}
