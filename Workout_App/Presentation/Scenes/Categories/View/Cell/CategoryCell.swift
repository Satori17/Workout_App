//
//  CategoryCell.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 03.08.22.
//

import UIKit

class CategoryCell: UITableViewCell {

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
        categoryNameLabel.text = " \(categories.name)"
        categoryImageView.image = categories.image        
    }
}
