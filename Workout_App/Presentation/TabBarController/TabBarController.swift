//
//  TabBarController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 03.08.22.
//

import UIKit

class TabBarController: UITabBarController {

    //MARK: - TabBar Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTabBarAppearence()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        checkTabBarAppearence()
    }
    
    //MARK: - Methods
    
    private func checkTabBarAppearence() {
        tabBar.tintColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
}
