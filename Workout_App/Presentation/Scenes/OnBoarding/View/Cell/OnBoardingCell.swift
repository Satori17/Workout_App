//
//  OnBoardingCell.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit
import Lottie

class OnBoardingCell: UICollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var animatedView: AnimationView!
    @IBOutlet weak var animationTitleLabel: UILabel!
    
    //MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Setup Method
    private func setupAnimatedView(withName name: String) {
        animatedView.animationSpeed = 1
        animatedView.animation = Animation.named(name)
        animatedView.loopMode = .loop
        animatedView.play()
    }
    
    //MARK: - Configure Method
    func configure(with data: OnBoardingModel) {
        setupAnimatedView(withName: data.animatedImage)
        animationTitleLabel.text = data.title
    }
}
