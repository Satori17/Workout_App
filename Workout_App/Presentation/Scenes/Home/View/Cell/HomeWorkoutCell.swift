//
//  HomeWorkoutCell.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol notificationReceivedDelegate: AnyObject {
    func appearMissedWorkouts(cell: HomeWorkoutCell, weekDay: String)
    func dismissCheckMark(cell: HomeWorkoutCell)
}

final class HomeWorkoutCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutSetsAndRepsLabel: UILabel!
    @IBOutlet weak var checkmarkBtn: UIButton!
    
    //MARK: - Mask Layers
    private let gradientMaskLayer = CAGradientLayer()
    private let gradientMaskLayer2 = CAGradientLayer()
    
    //MARK: - Timer Helper Properties
    private let timer = Timer()
    
    //MARK: - Notification Receiving Delegate
    weak var delegate: notificationReceivedDelegate?
    
    //MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellComponents()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: NotificationName.openFromNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientMaskLayer.frame = self.layer.bounds
        gradientMaskLayer2.frame = self.layer.bounds
    }
    
    //MARK: - IBAction
    @IBAction func workoutChecked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        timer.setDismissTimer(duration: 0.5) { [weak self] in
            sender.isSelected = false
            self?.workoutNameLabel.textColor = UIColor.ColorKey.adaptive
            if let cell = self {
                self?.delegate?.dismissCheckMark(cell: cell)
            }
        }
    }
    
    //MARK: - Methods
    @objc func notificationReceived(_ sender: Notification) {
        guard let object = sender.object as? String else { return }
        delegate?.appearMissedWorkouts(cell: self, weekDay: object)
    }
    
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
        workoutNameLabel.textColor = workout.isMissed ? .systemRed : UIColor.ColorKey.adaptive
        workoutNameLabel.text = workout.name
        workoutSetsAndRepsLabel.text = "\(workout.sets)x \(workout.reps) reps"
    }
}
