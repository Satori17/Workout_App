//
//  CategoryCell.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 03.08.22.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    //MARK: - Properties
    private let gradientMaskLayer = CAGradientLayer()
    
    //MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        fakeView.withAppDesign(layer: gradientMaskLayer, curvedCorners: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientMaskLayer.frame = self.layer.bounds
    }
    
    //MARK: - Methods
    func configure(with categories: CategoryViewModel) {
        categoryImageView.contentMode = categories.name == UIImageView.ImageKey.cardio ? .scaleAspectFit : .center
        categoryNameLabel.text =  "\(CustomTitle.space)\(categories.name)"
        categoryImageView.image = categories.image
    }
}
