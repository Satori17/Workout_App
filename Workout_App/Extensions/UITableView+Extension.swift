//
//  UICollectionView+Extension.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 03.08.22.
//

import UIKit

extension UITableViewCell {
    static var identifier: String { String(describing: self) }
    static var nibFile: UINib { UINib(nibName: identifier, bundle: nil) }
}

extension UITableView {
    func registerNib<T: UITableViewCell>(class: T.Type) {
        self.register(T.nibFile, forCellReuseIdentifier: T.identifier)
    }
}
