//
//  WorkoutDetailView.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.08.22.
//

import UIKit

protocol licenseDetailsDelegate: AnyObject {
    func openLicenseDetails()
}

protocol SaveWorkoutDelegate: AnyObject {
    func saveWorkout()
}

final class WorkoutDetailView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var secondaryImageView: UIImageView!
    @IBOutlet weak var addWorkoutBtn: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet var frontMuscleImageViews: [UIImageView]!
    @IBOutlet var backMuscleImageViews: [UIImageView]!
    @IBOutlet weak var frontMuscleNameLabel: UILabel!
    @IBOutlet weak var backMuscleNameLabel: UILabel!
    @IBOutlet weak var variationsHeaderLabel: UILabel!
    @IBOutlet weak var workoutVariationsCollectionView: UICollectionView!
    @IBOutlet weak var licenseHeaderLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var licenseContentStackView: UIStackView!
    @IBOutlet weak var licenseAuthorTemplateLabel: UILabel!
    @IBOutlet weak var licenseAuthorLabel: UILabel!
    @IBOutlet weak var licenseDetailsBtn: UIButton!
    //MARK: - Constraints
    @IBOutlet weak var licenseHeaderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var variationsHeaderTopLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var variationsHeaderTopRightConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    var scrollView: UIScrollView?
    private let gradientMaskLayer = CAGradientLayer()
    
    //MARK: - Data
    private var workoutVariations: [Displayable] = []
    var chosenVariation: Displayable?
    
    //MARK: - Delegates
    weak var licenseDelegate: licenseDetailsDelegate?
    weak var workoutSaverDelegate: SaveWorkoutDelegate?
    
    //MARK: - Object Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientMaskLayer.frame = self.layer.bounds
    }
    
    //MARK: - IBActions
    @IBAction func addWorkoutBtnTapped(_ sender: UIButton) {
        workoutSaverDelegate?.saveWorkout()
    }
    
    @IBAction func licenseDetailsBtnTapped(_ sender: UIButton) {
        licenseDelegate?.openLicenseDetails()
    }
    
    //MARK: - Initial methods
    private func initSubviews() {
        let nib = UINib(nibName: "WorkoutDetailView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.clipsToBounds = true
        contentView.withAppDesign(layer: gradientMaskLayer, curvedCorners: false)
        addWorkoutBtn.maskCurved(corner: [.bottomLeft, .bottomRight])
        setupCollectionView()
        addSubview(contentView)
    }
    
    private func setupCollectionView() {
        workoutVariationsCollectionView.registerNib(class: WorkoutCell.self)
        workoutVariationsCollectionView.delegate = self
        workoutVariationsCollectionView.dataSource = self
        if let flowLayout = self.workoutVariationsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 10
            flowLayout.scrollDirection = .horizontal
        }
        workoutVariationsCollectionView.addShadow(ofRadius: 5.0)
    }
    
    func configure(with workout: Displayable) {
        scrollView?.scrollToTop(animated: true)
        nameLabel.text = workout.name
        setupImages(ofWorkout: workout)
        categoryLabel.text = workout.category.name
        equipmentLabel.text = formattedEquipment(ofWorkout: workout)
        descriptionLabel.text = workout.description
        commentsLabel.text = formattedComment(ofWorkout: workout)
        languageLabel.text = workout.language.fullName
        setupMuscleImage(ofWorkout: workout)
        licenseLabel.text = formattedLicense(ofWorkout: workout)
        licenseAuthorLabel.text = workout.licenseAuthor
        workoutVariations = workout.variations
        reconfigureVariationConstraints()
        reconfigureLicenseConstraints()
    }
    
    //MARK: - Constraints Reconfigurations
    private func reconfigureVariationConstraints() {
        guard !workoutVariations.isEmpty else {
            variationsHeaderLabel.isHidden = true
            workoutVariationsCollectionView.isHidden = true
            licenseHeaderTopConstraint.isActive = false
            variationsHeaderTopLeftConstraint.isActive = false
            variationsHeaderTopRightConstraint.isActive = false
            if let licenseHeader = licenseHeaderLabel {
                NSLayoutConstraint(
                    item: licenseHeader,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: frontMuscleNameLabel,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: 20
                ).isActive = true
            }
            return
        }
    }
    
    private func reconfigureLicenseConstraints() {
        guard !addWorkoutBtn.isHidden else {
            licenseHeaderLabel.removeFromSuperview()
            licenseContentStackView.removeFromSuperview()
            licenseAuthorTemplateLabel.removeFromSuperview()
            licenseAuthorLabel.removeFromSuperview()
            licenseDetailsBtn.removeFromSuperview()
            if let frontMuscleName = frontMuscleNameLabel {
                NSLayoutConstraint(
                    item: frontMuscleName,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: safeAreaLayoutGuide,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: 20
                ).isActive = true
            }
            return
        }
    }
    
    //MARK: - Setup Helper methods
    private func setupImages(ofWorkout workout: Displayable) {
        if let firstImage = workout.images.first {
            mainImageView.getImage(from: firstImage.image)
        }
        
        if let lastImage = workout.images.last {
            if lastImage.isMain {
                secondaryImageView.isHidden = true
            } else {
                secondaryImageView.isHidden = false
                secondaryImageView.getImage(from: lastImage.image)
            }
        }        
    }
    
    private func setupMuscleImage(ofWorkout workout: Displayable) {
        var occupiedFrontImageCounter = 0
        var occupiedBackImageCounter = 0
        
        if !workout.muscles.isEmpty {
            for (index, muscle) in workout.muscles.enumerated() {
                if muscle.isFront {
                    frontMuscleImageViews[index].loadFrom(URLAddress: muscle.imageUrlMain)
                    occupiedFrontImageCounter += 1
                    if var frontMuscleText = frontMuscleNameLabel.text {
                        frontMuscleText += !frontMuscleText.contains("\(muscle.name)") ? "\(muscle.name)\n" : ""
                    }
                } else {
                    backMuscleImageViews[index].loadFrom(URLAddress: muscle.imageUrlMain)
                    occupiedBackImageCounter += 1
                    if var backMuscleText = backMuscleNameLabel.text {
                        backMuscleText += !backMuscleText.contains("\(muscle.name)") ? "\(muscle.name)\n" : ""
                    }
                }
            }
        }
        
        if !workout.musclesSecondary.isEmpty {
            for muscle in workout.musclesSecondary {
                if muscle.isFront {
                    frontMuscleImageViews[occupiedFrontImageCounter].loadFrom(URLAddress: muscle.imageUrlSecondary)
                    occupiedFrontImageCounter += 1
                    if var frontMuscleText = frontMuscleNameLabel.text {
                        frontMuscleText += !frontMuscleText.contains("\(muscle.name)") ? "\(muscle.name)\n" : ""
                    }
                } else {
                    backMuscleImageViews[occupiedBackImageCounter].loadFrom(URLAddress: muscle.imageUrlSecondary)
                    occupiedBackImageCounter += 1
                    if var backMuscleText = backMuscleNameLabel.text {
                        backMuscleText += !backMuscleText.contains("\(muscle.name)") ? "\(muscle.name)\n" : ""
                    }
                }
            }
        }
    }
    
    private func formattedEquipment(ofWorkout workout: Displayable) -> String {
        return workout.equipment.map{ $0.name }.joined(separator: ", ")
    }
    
    private func formattedComment(ofWorkout workout: Displayable) -> String {
        if !workout.comments.isEmpty {
            return workout.comments.map{ $0.comment }.joined(separator: "\n")
        } else {
            return "Comments not found"
        }
    }
    
    private func formattedLicense(ofWorkout workout: Displayable) -> String {
        "\(workout.license.licenseInfo.fullName) (\(workout.license.licenseInfo.shortName))"
    }
}

//MARK: - delegate protocol
extension WorkoutDetailView: WorkoutDetailsDelegate {
    
    func getWorkoutDetails(cell: WorkoutCell) {
        if let indexPath = workoutVariationsCollectionView.indexPath(for: cell) {
            let currentWorkout = workoutVariations[indexPath.row]
            self.configure(with: currentWorkout)
            chosenVariation = currentWorkout
            workoutVariationsCollectionView.reloadData()
        }
    }
}

//MARK: - ColletionView Delegate, DataSource & FlowLayout
extension WorkoutDetailView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        workoutVariations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkoutCell
        let currentWorkout = workoutVariations[indexPath.row]
        if let currentWorkout = currentWorkout as? WorkoutViewModel {
            cell.configure(with: currentWorkout)
        }
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 250)
    }
}
