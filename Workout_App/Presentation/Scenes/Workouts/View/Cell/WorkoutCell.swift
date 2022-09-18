//
//  WorkoutCell.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 06.08.22.
//

import UIKit

protocol WorkoutDetailsDelegate: AnyObject {
    func getWorkoutDetails(cell: WorkoutCell)
}

class WorkoutCell: UICollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutDescriptionLabel: UILabel!
    @IBOutlet weak var seeMoreBtn: UIButton!
    
    //MARK: - Properties
    private let gradientMaskLayer = CAGradientLayer()
    weak var delegate: WorkoutDetailsDelegate?
    
    //MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup(cell: self)
    }
    
    //MARK: - IBActions
    @IBAction func seeMoreBtnTapped(_ sender: UIButton) {
        self.delegate?.getWorkoutDetails(cell: self)
    }
    
    //MARK: - Setup Method
    private func setup(cell: UICollectionViewCell) {
        cell.layer.cornerRadius = 15
        cell.withAppDesign(layer: gradientMaskLayer, color: UIColor.Gradient.whiteOption, curvedCorners: true)
        seeMoreBtn.maskCurved(corner: .topLeft)
    }
    
    //MARK: - Configure Method
    func configure(with workouts: WorkoutViewModel) {
        if let mainImage = workouts.images.first?.image {
        workoutImageView.getImage(from: mainImage)
        }
        workoutNameLabel.text = workouts.name
        workoutDescriptionLabel.text = workouts.description
    }
}
