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
        //draw(imageBackgroundView.frame)
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
    
//    func gradientForView(with gradientMask: CAGradientLayer) {
//        gradientMask.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
//        //gradientMask.startPoint = CGPoint(x: 0.0, y: 0.0)
//        //gradientMask.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientMask.locations = [0.0, 0.7]
//        gradientMask.frame = imageBackgroundView.bounds
//        imageBackgroundView.layer.insertSublayer(gradientMask, at: 0)
//    }
    
//    override func draw(_ rect: CGRect) {
//        let bezierPath = UIBezierPath()
//        let layerWidth = layer.frame.width
//        let layerHeight = layer.frame.height
//        //defining points
//        bezierPath.move(to: CGPoint(x: layerWidth, y: layerHeight))
//        bezierPath.addLine(to: CGPoint(x: layerWidth, y: 0))
//        bezierPath.addLine(to: CGPoint(x: layerWidth/3, y: 0))
//        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
//        bezierPath.close()
//        //masking path
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = bezierPath.cgPath
//        layer.mask = shapeLayer
//        shapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
//    }

}
