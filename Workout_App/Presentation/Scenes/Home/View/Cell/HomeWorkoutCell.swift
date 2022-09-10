//
//  HomeWorkoutCell.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

class HomeWorkoutCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutSetsAndRepsLabel: UILabel!
    @IBOutlet weak var checkmarkBtn: UIButton!
    
    //MARK: - Properties
    
    private let gradientMaskLayer = CAGradientLayer()
    private let gradientMaskLayer2 = CAGradientLayer()

    //MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellComponents()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientMaskLayer.frame = self.layer.bounds
    }
    
    //MARK: - IBAction
    
    @IBAction func workoutChecked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    //MARK: - Methods
    
    private func setupCellComponents() {
        fakeView.withAppDesign(layer: gradientMaskLayer, color: UIColor.Gradient.whiteOption.withAlphaComponent(0.5), curvedCorners: false)
        checkmarkBtn.layer.masksToBounds = true
        checkmarkBtn.layer.cornerRadius = checkmarkBtn.frame.width/2
        workoutImageView.gradientForImageView(gradient: gradientMaskLayer2)
    }
    
    func configure(with workout: CoreWorkoutViewModel) {
        if let mainImage = workout.images.first?.image {
            workoutImageView.getImage(from: mainImage)
        }
        workoutNameLabel.text = workout.name
        workoutSetsAndRepsLabel.text = "\(workout.sets)x \(workout.reps) reps"
    }
    
}
