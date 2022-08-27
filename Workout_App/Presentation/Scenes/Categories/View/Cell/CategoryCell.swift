//
//  CategoryCell.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 03.08.22.
//

import UIKit

class CategoryCell: UITableViewCell {

    //MARK: - IBOutlets

    @IBOutlet weak var fakeView: UIView!{
        didSet {
            fakeView.withAppDesign(layer: gradientMaskLayer)
        }
    }
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    //MARK: - Vars
    private let gradientMaskLayer = CAGradientLayer()
    
    //MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientMaskLayer.frame = self.layer.bounds
    }
    
    //MARK: - Methods
    
    func configure(with categories: CategoryViewModel) {
        categoryNameLabel.text = " \(categories.name)"
        categoryImageView.image = categories.image        
    }

}
